// Inicializar renderizado de íconos Lucide
document.addEventListener("DOMContentLoaded", () => {
    lucide.createIcons();
});

// Función para cambiar de pantalla interactivamente
function showScreen(screenId) {
    // Ocultar todas las pantallas
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => screen.classList.remove('active'));
    
    // Activar la pantalla objetivo
    const targetScreen = document.getElementById(screenId);
    if(targetScreen) {
        targetScreen.classList.add('active');
    }
    
    // Volver a cargar íconos
    lucide.createIcons();
}