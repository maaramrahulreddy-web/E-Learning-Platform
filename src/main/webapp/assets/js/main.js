function openModal(id) {
    document.getElementById(id).classList.add('show');
    document.body.style.overflow = 'hidden';
}

function closeModal(id) {
    document.getElementById(id).classList.remove('show');
    document.body.style.overflow = '';
}

document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('show');
        document.body.style.overflow = '';
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.show').forEach(function (m) {
            m.classList.remove('show');
            document.body.style.overflow = '';
        });
    }
});

document.addEventListener('DOMContentLoaded', function () {
    var path = window.location.pathname;
    document.querySelectorAll('.sidebar-nav .nav-link').forEach(function (link) {
        var href = link.getAttribute('href');
        if (href && path.indexOf(href.split('?')[0]) !== -1) {
            link.classList.add('active');
        }
    });
});

setTimeout(function () {
    document.querySelectorAll('.alert-custom').forEach(function (el) {
        el.style.transition = 'opacity 0.6s ease';
        el.style.opacity = '0';
        setTimeout(function () { el.remove(); }, 600);
    });
}, 4000);

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.progress-bar-fill').forEach(function (bar) {
        var target = bar.style.width;
        bar.style.width = '0%';
        setTimeout(function () { bar.style.width = target; }, 300);
    });
});