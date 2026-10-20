package com.example.sikap_project

import android.content.Intent
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

class MainActivity : FlutterActivity() {
    private var sharedContentEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARED_CONTENT_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialSharedContent" -> result.success(sharedContentFromIntent(intent))
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_TOAST_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showToast" -> {
                        val message = call.argument<String>("message")
                        if (message.isNullOrBlank()) {
                            result.error("INVALID_MESSAGE", "Toast message is required.", null)
                        } else {
                            Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SECURE_STORAGE_CHANNEL)
            .setMethodCallHandler { call, result ->
                val key = call.argument<String>("key")
                if (key.isNullOrBlank()) {
                    result.error("INVALID_KEY", "A secure-storage key is required.", null)
                    return@setMethodCallHandler
                }
                try {
                    val preferences = getSharedPreferences(SECURE_STORAGE_PREFS, MODE_PRIVATE)
                    when (call.method) {
                        "read" -> {
                            val encoded = preferences.getString(key, null)
                            result.success(encoded?.let { decryptToken(it) })
                        }
                        "write" -> {
                            val value = call.argument<String>("value")
                            if (value.isNullOrEmpty()) {
                                result.error("INVALID_VALUE", "A token value is required.", null)
                            } else {
                                preferences.edit().putString(key, encryptToken(value)).apply()
                                result.success(null)
                            }
                        }
                        "delete" -> {
                            preferences.edit().remove(key).apply()
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                } catch (error: Exception) {
                    result.error("SECURE_STORAGE_ERROR", error.message, null)
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SHARED_CONTENT_EVENTS)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sharedContentEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    sharedContentEventSink = null
                }
            })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        sharedContentFromIntent(intent)?.let { sharedContentEventSink?.success(it) }
    }

    private fun sharedContentFromIntent(intent: Intent?): Map<String, String>? {
        if (intent?.action != Intent.ACTION_SEND) return null

        val text = intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()
            ?.trim()
            .orEmpty()
        val subject = intent.getStringExtra(Intent.EXTRA_SUBJECT)?.trim().orEmpty()
        if (text.isEmpty() && subject.isEmpty()) return null

        return mapOf("text" to text, "subject" to subject)
    }

    private fun encryptToken(token: String): String {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, getOrCreateStorageKey())
        val encrypted = cipher.doFinal(token.toByteArray(StandardCharsets.UTF_8))
        val payload = ByteBuffer.allocate(cipher.iv.size + encrypted.size)
            .put(cipher.iv)
            .put(encrypted)
            .array()
        return Base64.encodeToString(payload, Base64.NO_WRAP)
    }

    private fun decryptToken(encoded: String): String {
        val payload = Base64.decode(encoded, Base64.NO_WRAP)
        val buffer = ByteBuffer.wrap(payload)
        val iv = ByteArray(12)
        buffer.get(iv)
        val encrypted = ByteArray(buffer.remaining())
        buffer.get(encrypted)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(
            Cipher.DECRYPT_MODE,
            getOrCreateStorageKey(),
            GCMParameterSpec(128, iv)
        )
        return String(cipher.doFinal(encrypted), StandardCharsets.UTF_8)
    }

    private fun getOrCreateStorageKey(): SecretKey {
        val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (keyStore.getKey(SECURE_STORAGE_KEY_ALIAS, null) as? SecretKey)?.let {
            return it
        }
        val generator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            "AndroidKeyStore"
        )
        generator.init(
            KeyGenParameterSpec.Builder(
                SECURE_STORAGE_KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setRandomizedEncryptionRequired(true)
                .build()
        )
        return generator.generateKey()
    }

    private companion object {
        const val SHARED_CONTENT_CHANNEL = "com.sikap/shared_content"
        const val SHARED_CONTENT_EVENTS = "com.sikap/shared_content/events"
        const val SYSTEM_TOAST_CHANNEL = "com.sikap/system_toast"
        const val SECURE_STORAGE_CHANNEL = "com.sikap/secure_storage"
        const val SECURE_STORAGE_PREFS = "sikap_encrypted_tokens"
        const val SECURE_STORAGE_KEY_ALIAS = "sikap_jwt_key"
    }
}
