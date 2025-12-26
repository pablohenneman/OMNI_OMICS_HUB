(function () {
  function setActiveStep(stepId) {
    var modules = document.querySelectorAll('[data-module]');
    modules.forEach(function (module) {
      module.classList.toggle('active', module.getAttribute('data-module') === stepId);
    });

    var tabs = document.querySelectorAll('[data-step]');
    tabs.forEach(function (tab) {
      tab.classList.toggle('active', tab.getAttribute('data-step') === stepId);
    });
  }

  function getStepFromQuery() {
    var params = new URLSearchParams(window.location.search);
    return params.get('step');
  }

  var defaultStep = 'step0';
  var stepFromQuery = getStepFromQuery();
  if (stepFromQuery) {
    setActiveStep(stepFromQuery);
  } else {
    setActiveStep(defaultStep);
  }

  var navLinks = document.querySelectorAll('[data-step]');
  navLinks.forEach(function (link) {
    link.addEventListener('click', function (event) {
      if (link.tagName.toLowerCase() === 'a' && link.getAttribute('href')) {
        return;
      }
      event.preventDefault();
      var step = link.getAttribute('data-step');
      setActiveStep(step);
      history.replaceState({}, '', window.location.pathname + '?step=' + step);
    });
  });
})();
