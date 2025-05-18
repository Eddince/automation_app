package com.example.automation_app

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

class MyAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Aquí detectamos eventos de otras apps (ej: clics, texto)
        val rootNode = rootInActiveWindow
        rootNode?.let { performAutoClick(it) }
    }

    private fun performAutoClick(node: AccessibilityNodeInfo) {
        // Ejemplo: Buscar un botón con texto "Aceptar" y hacer clic
        val button = node.findAccessibilityNodeInfosByText("Aceptar")
        if (button.isNotEmpty()) {
            button[0].performAction(AccessibilityNodeInfo.ACTION_CLICK)
        }
    }

    override fun onInterrupt() {}
}