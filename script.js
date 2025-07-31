// Mobile menu toggle 
//This script toggles the mobile navigation menu

 document.addEventListener('DOMContentLoaded', function () {
  var menuButton = document.getElementById('mobile-menu-button');
  var mobileMenu = document.getElementById('mobile-menu');

  if (menuButton && mobileMenu) {
    menuButton.addEventListener('click', function () {
      mobileMenu.classList.toggle('hidden');
    });
    // Close menu when any link inside mobile menu is clicked
    var menuLinks = mobileMenu.querySelectorAll('a');
    menuLinks.forEach(function(link) {
      link.addEventListener('click', function () {
        mobileMenu.classList.add('hidden');
      });
    });
  }
});


// FAQ expand/collapse functionality
 document.addEventListener('DOMContentLoaded', function () {
      const faqButtons = document.querySelectorAll('.max-w-3xl .bg-white > button');
      faqButtons.forEach(function (btn) {
        btn.addEventListener('click', function () {
          const answer = btn.parentElement.querySelector('.faq-answer');
          const isOpen = answer.style.display !== 'none' && answer.style.display !== '';
          document.querySelectorAll('.faq-answer').forEach(function (a) {
            a.style.display = 'none';
          });
          answer.style.display = isOpen ? 'none' : 'block';
        });
      });
    });