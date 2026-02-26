(() => {
  const suspiciousSqlPattern = /(?:--|\/\*|\*\/|;|\b(SELECT|UNION|INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|TRUNCATE|EXEC|OR\s+1\s*=\s*1)\b)/i;
  const forms = document.querySelectorAll('form');

  forms.forEach((form) => {
    form.addEventListener('submit', (event) => {
      const fields = form.querySelectorAll('input[type="text"], input[type="email"], textarea');

      for (const field of fields) {
        const value = field.value.trim();

        if (value && suspiciousSqlPattern.test(value)) {
          event.preventDefault();
          field.setCustomValidity('Potential SQL injection pattern detected. Please remove SQL operators/keywords.');
          field.reportValidity();
          return;
        }

        field.setCustomValidity('');
      }
    });
  });
})();
