/**
 * BISPIRA WEB PORTAL INTERACTIVE LOGIC & GOJEK/GRAB STYLE REPEATING SCROLL ANIMATIONS
 */

document.addEventListener('DOMContentLoaded', () => {
  // Initialize AOS (Animate On Scroll) - REPEATS CONTINUOUSLY ON SCROLL UP & DOWN!
  if (typeof AOS !== 'undefined') {
    AOS.init({
      duration: 750,
      easing: 'ease-out-cubic',
      once: false,  // ANIMASI BERULANG SAAT SCROLL NAIK DAN TURUN!
      mirror: true, // RE-TRIGGER ANIMATIONS WHEN SCROLLING PAST BACK UP!
      offset: 60,
    });
  }

  // Ensure all Hero elements are 100% visible immediately
  const heroTitle = document.querySelector('.hero-title');
  const heroDesc = document.querySelector('.hero-desc');
  if (heroTitle) {
    heroTitle.style.opacity = '1';
    heroTitle.style.visibility = 'visible';
  }
  if (heroDesc) {
    heroDesc.style.opacity = '1';
    heroDesc.style.visibility = 'visible';
  }

  // GSAP Entrance Animations for Navbar Logo
  if (typeof gsap !== 'undefined') {
    gsap.from('.brand-logo-img', {
      duration: 1.2,
      scale: 0.6,
      rotation: -12,
      ease: 'elastic.out(1, 0.5)',
    });
  }

  // 3D Interactive Mouse & Touch Drag Rotation Engine
  const hero3dImg = document.getElementById('hero3dImg');
  const hero3dContainer = document.getElementById('hero3dContainer');

  if (hero3dContainer && hero3dImg) {
    let isDragging = false;
    let startX = 0;
    let startY = 0;
    let rotationY = 0;
    let rotationX = 0;

    hero3dContainer.addEventListener('mousedown', (e) => {
      isDragging = true;
      startX = e.clientX;
      startY = e.clientY;
    });

    window.addEventListener('mouseup', () => {
      isDragging = false;
    });

    window.addEventListener('mousemove', (e) => {
      if (!isDragging) return;
      const deltaX = e.clientX - startX;
      const deltaY = e.clientY - startY;
      startX = e.clientX;
      startY = e.clientY;

      rotationY += deltaX * 0.7;
      rotationX -= deltaY * 0.4;
      rotationX = Math.max(-25, Math.min(25, rotationX));

      hero3dImg.style.transform = `perspective(1000px) rotateY(${rotationY}deg) rotateX(${rotationX}deg) scale(1.04)`;
    });

    // Touch events for mobile/tablet drag
    hero3dContainer.addEventListener('touchstart', (e) => {
      isDragging = true;
      startX = e.touches[0].clientX;
      startY = e.touches[0].clientY;
    }, { passive: true });

    window.addEventListener('touchend', () => {
      isDragging = false;
    });

    window.addEventListener('touchmove', (e) => {
      if (!isDragging) return;
      const deltaX = e.touches[0].clientX - startX;
      const deltaY = e.touches[0].clientY - startY;
      startX = e.touches[0].clientX;
      startY = e.touches[0].clientY;

      rotationY += deltaX * 0.7;
      rotationX -= deltaY * 0.4;
      rotationX = Math.max(-25, Math.min(25, rotationX));

      hero3dImg.style.transform = `perspective(1000px) rotateY(${rotationY}deg) rotateX(${rotationX}deg) scale(1.04)`;
    }, { passive: true });
  }
});

// SERVICE CATEGORY FILTER (GOJEK / GRAB CATEGORY TABS)
function filterServices(category) {
  const tabs = document.querySelectorAll('.pillar-tab');
  tabs.forEach(t => t.classList.remove('active'));

  if (event && event.target) {
    event.target.classList.add('active');
  }

  const cards = document.querySelectorAll('.service-card');
  cards.forEach(card => {
    if (category === 'all') {
      card.style.display = 'flex';
    } else {
      if (card.classList.contains(`cat-${category}`)) {
        card.style.display = 'flex';
      } else {
        card.style.display = 'none';
      }
    }
  });

  if (typeof gsap !== 'undefined') {
    gsap.fromTo(
      '#servicesGrid .service-card[style*="display: flex"]',
      { opacity: 0, y: 15 },
      { opacity: 1, y: 0, duration: 0.4, stagger: 0.05, ease: 'power2.out' }
    );
  }
}

// SHOWCASE APP TAB SWITCHER (NEW 4-APP SHOWCASE)
function switchShowcaseTab(tabName) {
  const tabs = document.querySelectorAll('.showcase-tab');
  tabs.forEach(btn => btn.classList.remove('active'));

  const panels = document.querySelectorAll('.showcase-panel');
  panels.forEach(panel => panel.style.display = 'none');

  if (event && event.target) {
    event.target.classList.add('active');
  }

  const targetPanel = document.getElementById(`showcase-${tabName}`);
  if (targetPanel) {
    targetPanel.style.display = 'block';

    if (typeof gsap !== 'undefined') {
      gsap.fromTo(
        targetPanel,
        { opacity: 0, y: 20 },
        { opacity: 1, y: 0, duration: 0.4, ease: 'power2.out' }
      );
    }
  }
}

// TAB SWITCHER FOR REGISTRATION FORMS
function switchRegTab(tabName) {
  const tabs = document.querySelectorAll('.reg-tab-buttons .tab-btn');
  tabs.forEach(btn => btn.classList.remove('active'));

  const driverForm = document.getElementById('form-driver');
  const merchantForm = document.getElementById('form-merchant');
  const branchForm = document.getElementById('form-branch');

  driverForm.style.display = 'none';
  merchantForm.style.display = 'none';
  branchForm.style.display = 'none';

  let activeTarget = null;

  if (tabName === 'driver') {
    driverForm.style.display = 'block';
    tabs[0].classList.add('active');
    activeTarget = driverForm;
  } else if (tabName === 'merchant') {
    merchantForm.style.display = 'block';
    tabs[1].classList.add('active');
    activeTarget = merchantForm;
  } else if (tabName === 'branch') {
    branchForm.style.display = 'block';
    tabs[2].classList.add('active');
    activeTarget = branchForm;
  }

  if (activeTarget && typeof gsap !== 'undefined') {
    gsap.fromTo(
      activeTarget,
      { opacity: 0, scale: 0.98 },
      { opacity: 1, scale: 1, duration: 0.35, ease: 'power2.out' }
    );
  }
}

// INTERACTIVE FAQ ACCORDION TOGGLE
function toggleFaq(button) {
  const faqItem = button.parentElement;
  const isAlreadyActive = faqItem.classList.contains('active');

  // Close all FAQs first for clean accordion behavior
  document.querySelectorAll('.faq-item').forEach(item => {
    item.classList.remove('active');
  });

  if (!isAlreadyActive) {
    faqItem.classList.add('active');
  }
}

// FORM SUBMISSION HANDLER WITH FEEDBACK
function handleFormSubmit(event, roleTitle) {
  event.preventDefault();
  alert(`✅ Terima kasih! Pendaftaran ${roleTitle} BISPIRA berhasil dikirim.\n\nTim Verification HQ & Lisensi Cabang kami akan menghubungi WhatsApp Anda dalam 1x24 Jam.`);
  event.target.reset();
}

// MOBILE NAVIGATION TOGGLE
function toggleMobileNav() {
  const navLinks = document.querySelector('.nav-links');
  if (navLinks.style.display === 'flex') {
    navLinks.style.display = 'none';
  } else {
    navLinks.style.display = 'flex';
    navLinks.style.flexDirection = 'column';
    navLinks.style.position = 'absolute';
    navLinks.style.top = '70px';
    navLinks.style.left = '0';
    navLinks.style.right = '0';
    navLinks.style.background = '#FFFFFF';
    navLinks.style.padding = '20px';
    navLinks.style.boxShadow = '0 10px 30px rgba(0,0,0,0.1)';
  }
}
