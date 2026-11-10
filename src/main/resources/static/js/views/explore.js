/**
 * Explore — browse the same curated places used by the chatbot.
 */
import { api } from '../api.js';
import { icon, escapeHtml, skeletonCards } from '../ui.js';

const SORTS = [
  { key: 'closest', label: 'Closest' },
  { key: 'name', label: 'A–Z' }
];

const CATEGORY_ICONS = { food: 'food', banking: 'wallet', grooming: 'salon', fun: 'event' };
const CATEGORY_ALIASES = {
  'food-drinks': 'food',
  restaurants: 'food',
  beauty: 'grooming',
  salons: 'grooming',
  events: 'fun'
};

export async function renderExplore(container, params = {}) {
  const filters = {
    q: params.q || '',
    category: CATEGORY_ALIASES[params.category] || params.category || '',
    sort: params.sort === 'name' ? 'name' : 'closest'
  };

  let places = [];
  let categories = [];

  container.innerHTML = `
    <div class="greet">
      <div>
        <p class="greet__hello">Find it in the zone</p>
        <h1 class="greet__title">Explore</h1>
      </div>
    </div>

    <p class="field__hint" style="margin-top:10px">
      ${icon('pin', 12)} The same curated place list used by the chatbot. Distances are measured from Richfield.
    </p>

    <form id="explore-search" class="filter-bar">
      <span class="search-pill">
        ${icon('search', 18)}
        <input class="input" type="search" name="q" placeholder="Search these places…"
               aria-label="Search places" value="${escapeHtml(filters.q)}">
      </span>
    </form>

    <div class="chips" id="category-chips"></div>
    <div class="chips" id="sort-chips">
      ${SORTS.map((sort) => `
        <button class="chip ${sort.key === filters.sort ? 'is-active' : ''}" type="button"
                data-sort="${sort.key}">${sort.label}</button>`).join('')}
    </div>

    <div class="row row--between" style="margin:6px 0 12px">
      <span class="small muted" id="result-count">Loading places…</span>
      <button class="btn--link small" type="button" id="clear-filters" hidden>Clear</button>
    </div>

    <div id="results">${skeletonCards(3)}</div>`;

  const input = container.querySelector('#explore-search input');
  const categoryChips = container.querySelector('#category-chips');
  const results = container.querySelector('#results');
  const count = container.querySelector('#result-count');
  const clear = container.querySelector('#clear-filters');

  try {
    const [placeResult, configResult] = await Promise.all([
      api.assistantPlaces(),
      api.assistantConfig()
    ]);
    places = placeResult.data || [];
    categories = (configResult.data?.categories || [])
      .filter((category) => places.some((place) => place.category === category.id));
    if (!categories.some((category) => category.id === filters.category)) filters.category = '';

    categoryChips.innerHTML = `
      <button class="chip ${filters.category ? '' : 'is-active'}" type="button" data-category="">All places</button>
      ${categories.map((category) => `
        <button class="chip ${filters.category === category.id ? 'is-active' : ''}" type="button"
                data-category="${escapeHtml(category.id)}">${escapeHtml(category.label)}</button>`).join('')}`;

    categoryChips.addEventListener('click', (event) => {
      const chip = event.target.closest('[data-category]');
      if (!chip) return;
      filters.category = chip.dataset.category;
      categoryChips.querySelectorAll('[data-category]')
        .forEach((node) => node.classList.toggle('is-active', node === chip));
      renderResults();
    });

    container.querySelector('#sort-chips').addEventListener('click', (event) => {
      const chip = event.target.closest('[data-sort]');
      if (!chip) return;
      filters.sort = chip.dataset.sort;
      container.querySelectorAll('[data-sort]')
        .forEach((node) => node.classList.toggle('is-active', node === chip));
      renderResults();
    });

    input.addEventListener('input', () => {
      filters.q = input.value.trim();
      clearTimeout(renderResults.timer);
      renderResults.timer = setTimeout(renderResults, 180);
    });

    container.querySelector('#explore-search').addEventListener('submit', (event) => {
      event.preventDefault();
      filters.q = input.value.trim();
      renderResults();
    });

    clear.addEventListener('click', () => {
      filters.q = '';
      filters.category = '';
      filters.sort = 'closest';
      input.value = '';
      container.querySelectorAll('[data-sort]')
        .forEach((node) => node.classList.toggle('is-active', node.dataset.sort === 'closest'));
      categoryChips.querySelectorAll('[data-category]')
        .forEach((node) => node.classList.toggle('is-active', node.dataset.category === ''));
      renderResults();
    });

    renderResults();
  } catch (error) {
    count.textContent = 'Places could not be loaded';
    results.innerHTML = `<div class="card empty">
      <span class="empty__icon">${icon('alert', 22)}</span>
      <strong>Could not load the student directory</strong>
      <p class="muted small">${escapeHtml(error.message)}</p>
    </div>`;
  }

  function renderResults() {
    const needle = normalise(filters.q);
    const visible = places.filter((place) => {
      const matchesCategory = !filters.category || place.category === filters.category;
      const searchable = normalise([
        place.name, place.address, place.categoryLabel, place.description
      ].filter(Boolean).join(' '));
      return matchesCategory && (!needle || searchable.includes(needle));
    }).sort((a, b) => {
      if (filters.sort === 'name') return a.name.localeCompare(b.name);
      const aDistance = a.withinRadius && Number.isFinite(a.distanceMeters)
        ? a.distanceMeters : Number.POSITIVE_INFINITY;
      const bDistance = b.withinRadius && Number.isFinite(b.distanceMeters)
        ? b.distanceMeters : Number.POSITIVE_INFINITY;
      return aDistance - bDistance || a.name.localeCompare(b.name);
    });

    const active = Boolean(filters.q || filters.category);
    clear.hidden = !active;
    count.textContent = `${visible.length} of ${places.length} places`;
    results.innerHTML = visible.length
      ? visible.map(placeCard).join('')
      : `<div class="card empty">
           <span class="empty__icon">${icon('search', 22)}</span>
           <strong>No places match that search</strong>
           <p class="muted small">Try another name or category.</p>
         </div>`;
  }
}

function placeCard(place) {
  const glyph = CATEGORY_ICONS[place.category] || 'pin';
  const media = place.image
    ? `<img src="${escapeHtml(place.image)}" alt="${escapeHtml(place.name)}" loading="lazy">`
    : `<span class="place-card__glyph">${icon(glyph, 20)}</span>`;
  const distance = place.withinRadius && Number.isFinite(place.distanceMeters)
    ? `<span class="badge badge--violet place-card__badge">${icon('pin', 10)} ${place.distanceMeters ? `${place.distanceMeters} m from Richfield` : 'On campus'}</span>`
    : `<span class="badge badge--gold place-card__badge">Location unverified</span>`;

  return `
    <article class="place-card">
      <div class="place-card__media">${media}</div>
      <div class="place-card__body">
        <div class="place-card__top">
          <strong class="place-card__title">${escapeHtml(place.name)}</strong>
          ${distance}
        </div>
        <span class="place-card__cat">${escapeHtml(place.categoryLabel || 'Place')}</span>
        <span class="place-card__meta">${icon('pin', 11)} ${escapeHtml(place.address)}</span>
        ${place.description ? `<p class="small muted">${escapeHtml(place.description)}</p>` : ''}
        <div class="place-card__actions">
          <a class="btn btn--sm btn--ghost" href="${escapeHtml(place.directionsUrl)}"
             target="_blank" rel="noopener noreferrer">${icon('directions', 14)} Directions</a>
          <a class="btn btn--sm btn--ghost" href="#/assistant">${icon('chat', 14)} Ask the guide</a>
        </div>
      </div>
    </article>`;
}

function normalise(value) {
  return String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
}

