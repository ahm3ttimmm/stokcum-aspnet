// about-script.js
const misyon = document.getElementById('section-misyon');
const vizyon = document.getElementById('section-vizyon');
const bar = document.getElementById('progressBar');

function startProgressBar() {
    if (bar) {
        bar.style.transition = 'none';
        bar.style.width = '0%';

        setTimeout(() => {
            bar.style.transition = 'width 30s linear';
            bar.style.width = '100%';
        }, 50);
    }
}

function toggleSections() {
    if (misyon && vizyon) {
        if (misyon.style.display !== 'none') {
            misyon.style.display = 'none';
            vizyon.style.display = 'flex';
        } else {
            vizyon.style.display = 'none';
            vizyon.style.flex = 'flex';
            misyon.style.display = 'flex';
        }
        startProgressBar();
    }
}

// Sayfa tamamen yüklendiğinde DOM elemanlarını kontrol et ve başlat
document.addEventListener("DOMContentLoaded", function () {
    if (bar && misyon && vizyon) {
        startProgressBar();
        setInterval(toggleSections, 30000);
    }
});