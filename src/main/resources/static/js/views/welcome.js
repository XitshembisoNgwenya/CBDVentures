/**
 * Welcome screen — the first thing a new visitor sees.
 * Reference layout: Pretoria CBD hero photo, wordmark, one primary action
 * (Sign In) and one secondary (Create Account).
 */
import { icon } from '../ui.js?v=20261112-1';

const SEEN_KEY = 'cbd.welcomeSeen';

export async function renderWelcome(container) {
  window.__CBD_WELCOME_SEEN = true;
  try { localStorage.setItem(SEEN_KEY, '1'); } catch { /* welcome still works without storage */ }
  try { sessionStorage.setItem(SEEN_KEY, '1'); } catch { /* this tab remembers during the visit */ }

  container.innerHTML = `
    <div class="welcome">
      <div class="welcome__hero">
        <img src="/images/pretoria-cbd-welcome.jpg?v=20261112-1" alt="Aerial view of Pretoria CBD"
             width="526" height="526" fetchpriority="high" decoding="async">
      </div>

      <div>
        <h1 class="welcome__title">CBDVentures</h1>
        <p class="welcome__tag">Discover Pretoria Central</p>
        <div class="nxg-credit welcome__nxg-credit">
          <img class="nxg-mark" src="/images/nxg-logo.png?v=20261112-1" alt="NxG monogram">
          <span>A project by NxG Technologies</span>
        </div>
      </div>

      <div class="welcome__actions">
        <a class="btn btn--block" href="#/signin">Sign In</a>
        <a class="btn btn--ghost btn--block" href="#/signup">Create Account</a>
        <button class="btn--link" type="button" id="browse-as-guest" style="justify-self:center;margin-top:4px">
          Browse without an account
        </button>
      </div>

      <p class="welcome__legal">
        Everything here sits inside 1 km of Richfield Graduate Institute of Technology.
        Verified listings, student prices, and ${icon('shieldCheck', 13)} one review per person.
      </p>
    </div>`;

  const heroImage = container.querySelector('.welcome__hero img');
  heroImage.addEventListener('error', () => {
    if (heroImage.dataset.fallback) return;
    heroImage.dataset.fallback = '1';
    heroImage.src = '/images/hero-welcome.svg?v=20261112-1';
    heroImage.alt = 'Illustration of the Union Buildings at dusk';
  });

  container.querySelector('#browse-as-guest').addEventListener('click', () => {
    location.hash = '#/';
  });
}
