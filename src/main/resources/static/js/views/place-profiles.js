import { api } from '../api.js?v=20261110-4';

const PROFILE_ALIASES = {
  'student:xpresso': ['Xpresso Café'],
  'student:quick-bake': ['Quick Bake'],
  'student:family-chips': ['Family Chips & Rebels Pizza'],
  'student:absa-building': ['Absa Bank (ABSA Towers)'],
  'student:state-theatre': ['South African State Theatre']
};

export async function addBusinessProfiles(places) {
  let businesses = [];
  try {
    const result = await api.businesses({ page: 0, size: 100, sort: 'name' });
    businesses = result.data?.items || result.items || [];
  } catch { /* curated place cards still open their own detail page */ }

  return places.map((place) => ({
    ...place,
    businessProfile: findBusinessProfile(place, businesses)
  }));
}

export function findBusinessProfile(place, businesses = []) {
  const names = [place.name, ...(PROFILE_ALIASES[place.id] || [])]
    .map(normaliseName)
    .filter(Boolean);
  return businesses.find((business) => names.includes(normaliseName(business.name))) || null;
}

export function placeDetailsHref(place) {
  const businessId = place.businessProfile?.id;
  return businessId ? `#/business/${businessId}` : `#/place/${place.id}`;
}

function normaliseName(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, ' ')
    .trim();
}
