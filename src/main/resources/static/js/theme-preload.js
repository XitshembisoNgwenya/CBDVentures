(() => {
  let theme = 'dark';
  try {
    if (localStorage.getItem('cbd.theme') === 'light') theme = 'light';
  } catch { /* use the default when browser storage is unavailable */ }
  document.documentElement.dataset.theme = theme;
  document.documentElement.style.colorScheme = theme;
})();
