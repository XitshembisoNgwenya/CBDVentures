const TILE_URL = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

export function mountOpenStreetMap(container, { zone, businesses = [], focus = null }) {
  if (!window.L) {
    throw new Error('The interactive map could not load. Check your internet connection and try again.');
  }
  if (!zone) {
    throw new Error('The map area is not ready yet. Refresh the page and try again.');
  }

  const L = window.L;
  const center = [zone.anchorLatitude, zone.anchorLongitude];
  const map = L.map(container, { scrollWheelZoom: false, zoomControl: true }).setView(center, 16);
  map.attributionControl.setPrefix('');
  L.tileLayer(TILE_URL, {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener">OpenStreetMap</a> contributors'
  }).addTo(map);

  const radius = (zone.primaryRadiusKm || 1) * 1000;
  const zoneRing = L.circle(center, {
    radius,
    color: '#2563eb',
    weight: 2,
    fillColor: '#60a5fa',
    fillOpacity: 0.045
  }).addTo(map);

  L.marker(center, {
    icon: pinIcon(L, 'campus'),
    title: zone.anchorName || 'Richfield campus',
    riseOnHover: true
  }).bindPopup(textPopup(zone.anchorName || 'Richfield campus', zone.anchorAddress || '')).addTo(map);

  const markers = [];
  businesses.filter(hasCoordinates).forEach((business) => {
    const category = categoryGroup(business);
    const marker = L.marker([Number(business.latitude), Number(business.longitude)], {
      icon: pinIcon(L, category),
      title: business.name || 'CBDVentures place',
      riseOnHover: true
    }).bindPopup(businessPopup(business, zone));
    marker.addTo(map);
    markers.push({ marker, category });
  });

  if (focus && hasCoordinates(focus)) {
    map.setView([Number(focus.latitude), Number(focus.longitude)], 17);
  } else {
    map.fitBounds(zoneRing.getBounds(), { padding: [18, 18], maxZoom: 16 });
  }
  requestAnimationFrame(() => map.invalidateSize());

  return {
    setVisibleCategories(categories) {
      markers.forEach(({ marker, category }) => {
        if (categories.has(category)) marker.addTo(map);
        else map.removeLayer(marker);
      });
    }
  };
}

function hasCoordinates(business) {
  return business.latitude !== null && business.latitude !== undefined && business.latitude !== ''
    && business.longitude !== null && business.longitude !== undefined && business.longitude !== ''
    && Number.isFinite(Number(business.latitude)) && Number.isFinite(Number(business.longitude));
}

function categoryGroup(business) {
  const source = `${business.categorySlug || ''} ${business.categoryName || ''} ${business.iconKey || ''}`
    .toLowerCase();
  if (source.includes('study')) return 'study-spaces';
  if (source.includes('salon') || source.includes('personal care') || source.includes('grooming')) return 'salons';
  if (source.includes('restaurant') || source.includes('sit-down')) return 'restaurants';
  if (source.includes('food') || source.includes('eat')) return 'food-drinks';
  if (source.includes('event') || source.includes('entertain')) return 'events';
  return 'other';
}

function pinIcon(L, category) {
  return L.divIcon({
    className: 'map-marker-shell',
    html: `<span class="map-marker map-marker--${category}"><span></span></span>`,
    iconSize: [28, 36],
    iconAnchor: [14, 34],
    popupAnchor: [0, -30]
  });
}

function textPopup(title, detail) {
  const content = document.createElement('div');
  const heading = document.createElement('strong');
  heading.textContent = title;
  content.append(heading);
  if (detail) {
    const address = document.createElement('div');
    address.textContent = detail;
    content.append(address);
  }
  return content;
}

function businessPopup(business, zone) {
  const content = textPopup(business.name || 'CBDVentures place', business.categoryName || '');
  const details = [];
  if (Number.isFinite(Number(business.distanceKm))) {
    details.push(`${Number(business.distanceKm).toFixed(2)} km from Richfield`);
  }
  if (business.reviewCount) {
    details.push(`${Number(business.rating || 0).toFixed(1)} ★`);
  }
  if (business.priceLevel) details.push(String(business.priceLevel).replaceAll('_', ' '));
  if (details.length) {
    const line = document.createElement('div');
    line.textContent = details.join(' · ');
    content.append(line);
  }

  const actions = document.createElement('div');
  actions.className = 'map-popup-actions';
  const view = document.createElement('a');
  view.href = `#/business/${encodeURIComponent(business.id)}`;
  view.textContent = 'View place';
  actions.append(view);

  if (hasCoordinates(business)) {
    const directions = document.createElement('a');
    directions.href = directionsUrl(zone, business);
    directions.target = '_blank';
    directions.rel = 'noopener noreferrer';
    directions.textContent = 'Get directions';
    actions.append(directions);
  }
  content.append(actions);
  return content;
}

function directionsUrl(zone, business) {
  const origin = zone.anchorAddress || zone.anchorName || `${zone.anchorLatitude},${zone.anchorLongitude}`;
  const destination = `${business.latitude},${business.longitude}`;
  const query = new URLSearchParams({ api: '1', origin, destination, travelmode: 'walking' });
  return `https://www.google.com/maps/dir/?${query.toString()}`;
}
