import { api } from '../api.js?v=20261112-1';
import { icon, escapeHtml, distanceText } from '../ui.js?v=20261112-1';
import { addBusinessProfiles } from './place-profiles.js?v=20261112-1';

export async function renderPlace(container, id) {
  if (!id) { location.hash = '#/explore'; return; }

  container.innerHTML = `<div class="skeleton" style="height:300px;margin-top:8px"></div>`;

  let place;
  try {
    const result = await api.assistantPlace(id);
    place = result.data;
  } catch (error) {
    container.innerHTML = `<div class="card empty" style="margin-top:26px">
      <span class="empty__icon">${icon('alert', 22)}</span>
      <strong>That place is not available</strong>
      <p class="muted small">${escapeHtml(error.message)}</p>
      <a class="btn btn--sm" href="#/explore">Back to Explore</a>
    </div>`;
    return;
  }

  const [matched] = await addBusinessProfiles([place]);
  if (matched.businessProfile) {
    location.hash = `#/business/${matched.businessProfile.id}`;
    return;
  }

  const phone = extractPhone(place.description);
  const highlights = place.highlights || [];
  const distance = place.distanceMeters === null || place.distanceMeters === undefined
    ? 'Distance not confirmed' : distanceText(Number(place.distanceMeters) / 1000);

  container.innerHTML = `
    <div class="curated-place__hero">
      <img src="${escapeHtml(place.image || '/images/hero-welcome.svg')}" alt="${escapeHtml(place.name)}">
      <a class="biz-hero__back" href="#/explore" aria-label="Back to Explore">${icon('arrowLeft', 20)}</a>
    </div>
    <div class="biz-head">
      <span class="badge badge--violet">${escapeHtml(place.categoryLabel || 'Place')}</span>
      <h1>${escapeHtml(place.name)}</h1>
      <div class="biz-head__meta">
        <span>${icon('pin', 13)} ${escapeHtml(distance)}</span>
        <span class="rating-inline">${icon('star', 13)} No published ratings</span>
      </div>
    </div>
    <div class="biz-actions">
      <a class="btn" href="${escapeHtml(place.directionsUrl)}" target="_blank" rel="noopener noreferrer">
        ${icon('directions', 17)} Get Directions
      </a>
      ${phone ? `<a class="btn btn--ghost" href="tel:${escapeHtml(phone.replace(/[^\d+]/g, ''))}"
           aria-label="Call ${escapeHtml(place.name)}">${icon('phone', 17)}</a>` : ''}
    </div>
    ${place.description ? `<p class="muted" style="margin-top:16px;line-height:1.6">${escapeHtml(place.description)}</p>` : ''}
    <div class="card" style="margin-top:16px">
      <strong>Place details</strong>
      <div class="fact-list" style="margin-top:8px">
        <div class="fact"><span class="fact__icon">${icon('pin', 16)}</span>
          <div><div class="fact__label">Address</div><div class="fact__value">${escapeHtml(place.address)}</div></div>
        </div>
        ${phone ? `<div class="fact"><span class="fact__icon">${icon('phone', 16)}</span>
          <div><div class="fact__label">Contact number</div><div class="fact__value"><a href="tel:${escapeHtml(phone.replace(/[^\d+]/g, ''))}">${escapeHtml(phone)}</a></div></div>
        </div>` : `<div class="fact"><span class="fact__icon">${icon('phone', 16)}</span>
          <div><div class="fact__label">Contact number</div><div class="fact__value">Not provided for this place yet.</div></div>
        </div>`}
        <div class="fact"><span class="fact__icon">${icon('star', 16)}</span>
          <div><div class="fact__label">Ratings</div><div class="fact__value">No ratings have been published for this place yet.</div></div>
        </div>
      </div>
    </div>
    <div class="card" style="margin-top:14px">
      <strong>Amenities and study information</strong>
      ${highlights.length
        ? `<ul class="curated-place__highlights">${highlights.map((item) => `<li>${escapeHtml(item)}</li>`).join('')}</ul>`
        : `<p class="muted small" style="margin:8px 0 0">Amenities have not been listed for this place yet.</p>`}
    </div>
    ${place.verificationNote ? `<p class="field__hint" style="margin-top:12px">${escapeHtml(place.verificationNote)}</p>` : ''}
    <a class="btn btn--ghost" style="margin-top:14px" href="#/explore">${icon('arrowLeft', 15)} Back to Explore</a>`;
}

function extractPhone(description = '') {
  const match = String(description).match(/(?:phone|telephone|tel)\s*:\s*([+()\d][+()\d\s.-]{6,})/i);
  return match?.[1]?.trim().replace(/[.,;]+$/, '') || '';
}
