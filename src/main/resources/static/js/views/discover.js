/**
 * Discover — the home feed, using the same verified directory as Explore.
 */
import { api, session } from '../api.js?v=20261110-4';
import { icon, escapeHtml, skeletonCards } from '../ui.js?v=20261110-4';
import { placeCard } from './explore.js?v=20261110-4';
import { addBusinessProfiles } from './place-profiles.js?v=20261110-4';

const CATEGORY_ALIASES = {
  'food-drinks': 'food',
  restaurants: 'food',
  salons: 'grooming',
  'study-spaces': 'study',
  events: 'fun'
};

export async function renderDiscover(container, params = {}) {
  const firstName = session.user?.fullName?.split(' ')[0];
  container.innerHTML = `
    <div class="greet">
      <div>
        <p class="greet__hello">${firstName ? `Hello, ${escapeHtml(firstName)}!` : 'Hello, Explorer!'}</p>
        <h1 class="greet__title">Discover Pretoria Central</h1>
      </div>
    </div>

    <form class="search-pill" id="discover-search" style="margin-top:16px">
      ${icon('search', 18)}
      <input class="input" type="search" name="q" placeholder="Search places near Richfield…"
             aria-label="Search places" value="${escapeHtml(params.q || '')}">
    </form>

    <div class="chips" id="category-chips" aria-label="Place categories"></div>
    <div id="feed">${skeletonCards(2)}</div>`;

  container.querySelector('#discover-search').addEventListener('submit', (event) => {
    event.preventDefault();
    const query = event.target.q.value.trim();
    location.hash = query ? `#/explore?q=${encodeURIComponent(query)}` : '#/explore';
  });

  const chips = container.querySelector('#category-chips');
  const feed = container.querySelector('#feed');

  try {
    const [placesResult, configResult] = await Promise.all([
      api.assistantPlaces(),
      api.assistantConfig()
    ]);
    const places = await addBusinessProfiles(placesResult.data || []);
    const categories = (configResult.data?.categories || [])
      .filter((category) => places.some((place) => place.category === category.id));
    let selectedCategory = CATEGORY_ALIASES[params.category] || params.category || '';
    if (!categories.some((category) => category.id === selectedCategory)) selectedCategory = '';

    chips.innerHTML = `
      <button class="chip ${selectedCategory ? '' : 'is-active'}" type="button" data-category="">All places</button>
      ${categories.map((category) => `
        <button class="chip ${selectedCategory === category.id ? 'is-active' : ''}" type="button"
                data-category="${escapeHtml(category.id)}">${escapeHtml(category.label)}</button>`).join('')}`;

    chips.addEventListener('click', (event) => {
      const chip = event.target.closest('[data-category]');
      if (!chip) return;
      selectedCategory = chip.dataset.category;
      chips.querySelectorAll('[data-category]')
        .forEach((node) => node.classList.toggle('is-active', node === chip));
      renderPlaces();
    });

    renderPlaces();

    function renderPlaces() {
      const visible = places.filter((place) => !selectedCategory || place.category === selectedCategory)
        .sort((a, b) => {
          const distanceA = a.withinRadius && Number.isFinite(a.distanceMeters)
            ? a.distanceMeters : Number.POSITIVE_INFINITY;
          const distanceB = b.withinRadius && Number.isFinite(b.distanceMeters)
            ? b.distanceMeters : Number.POSITIVE_INFINITY;
          return distanceA - distanceB || a.name.localeCompare(b.name);
        });
      const categoryName = categories.find((category) => category.id === selectedCategory)?.label;
      const exploreUrl = selectedCategory
        ? `#/explore?category=${encodeURIComponent(selectedCategory)}` : '#/explore';

      feed.innerHTML = `
        <div class="section-head">
          <h2>${categoryName ? escapeHtml(categoryName) : 'Places near campus'}</h2>
          <a href="${exploreUrl}">See all ${visible.length}</a>
        </div>
        <p class="field__hint" style="margin:-4px 0 12px">
          The same curated businesses and study spaces listed on Explore.
        </p>
        ${visible.length
          ? `<div class="stack">${visible.slice(0, 6).map(placeCard).join('')}</div>`
          : `<div class="card empty"><strong>No places in this category yet.</strong></div>`}`;
    }
  } catch (error) {
    feed.innerHTML = `<div class="card empty">
      <span class="empty__icon">${icon('alert', 22)}</span>
      <strong>Places could not be loaded</strong>
      <p class="muted small">${escapeHtml(error.message)}</p>
      <a class="btn btn--sm" href="#/explore">Open Explore</a>
    </div>`;
  }
}
