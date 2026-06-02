/* ==========================================================================
   APP LOGIC - GO-SUPER INTERACTIVE SIMULATOR ENGINE
   Manages State, Animations, OSRM Path Interpolations, and Workflows
   ========================================================================== */

// --- GLOBAL SIMULATION STATE ---
let state = {
    // Balances
    userWallet: 150000,
    driverWallet: 120000,
    platformRevenue: 48250000,
    
    // Counter/Stats
    driversOnline: 245,
    totalDrivers: 1840,
    completedOrders: 6,
    pendingDrivers: 1,
    isDriverOnline: true,
    isDriverSuspended: false,
    
    // Configurations (Editable by Admin)
    tariffPerKm: 2500,
    minFare: 8000,
    serviceFee: 2000,
    platformCommission: 20, // 20%
    
    // Active orders states
    activeOrder: null, // Stores current order metadata
    currentSimStep: 0,
    simInterval: null
};

// Coordinate database for OSRM Simulator (Real GPS Jakarta Coordinates)
const LOCATIONS = {
    sudirman: { name: "Sudirman Center", lat: -6.2205, lng: 106.8122, coords: "(-6.2205, 106.8122)" },
    monas: { name: "Monas Park", lat: -6.1754, lng: 106.8272, coords: "(-6.1754, 106.8272)" },
    kemang: { name: "Kemang Square", lat: -6.2510, lng: 106.8150, coords: "(-6.2510, 106.8150)" },
    merchant_food: { name: "Senopati Resto (Ayam Geprek)", lat: -6.2285, lng: 106.8190, coords: "(-6.2285, 106.8190)" },
    merchant_health: { name: "Apotek Kimia Farma Benhil", lat: -6.2135, lng: 106.8040, coords: "(-6.2135, 106.8040)" }
};

// Paths for OSRM Route drawing (Real roads path points)
const ROUTE_PATHS = {
    "sudirman-monas": {
        distance: 8.2,
        duration: 15,
        points: [
            [-6.2205, 106.8122],
            [-6.2160, 106.8175],
            [-6.2085, 106.8227],
            [-6.1973, 106.8231],
            [-6.1865, 106.8236],
            [-6.1802, 106.8240],
            [-6.1754, 106.8272]
        ]
    },
    "monas-sudirman": {
        distance: 8.2,
        duration: 15,
        points: [
            [-6.1754, 106.8272],
            [-6.1802, 106.8240],
            [-6.1865, 106.8236],
            [-6.1973, 106.8231],
            [-6.2085, 106.8227],
            [-6.2160, 106.8175],
            [-6.2205, 106.8122]
        ]
    },
    "sudirman-kemang": {
        distance: 5.6,
        duration: 10,
        points: [
            [-6.2205, 106.8122],
            [-6.2300, 106.8140],
            [-6.2420, 106.8135],
            [-6.2510, 106.8150]
        ]
    },
    "kemang-sudirman": {
        distance: 5.6,
        duration: 10,
        points: [
            [-6.2510, 106.8150],
            [-6.2420, 106.8135],
            [-6.2300, 106.8140],
            [-6.2205, 106.8122]
        ]
    },
    "monas-kemang": {
        distance: 12.4,
        duration: 22,
        points: [
            [-6.1754, 106.8272],
            [-6.1865, 106.8236],
            [-6.1973, 106.8231],
            [-6.2085, 106.8227],
            [-6.2205, 106.8122],
            [-6.2350, 106.8130],
            [-6.2510, 106.8150]
        ]
    },
    "kemang-monas": {
        distance: 12.4,
        duration: 22,
        points: [
            [-6.2510, 106.8150],
            [-6.2350, 106.8130],
            [-6.2205, 106.8122],
            [-6.2085, 106.8227],
            [-6.1973, 106.8231],
            [-6.1865, 106.8236],
            [-6.1754, 106.8272]
        ]
    },
    "food-pickup": {
        distance: 3.5,
        duration: 7,
        points: [
            [-6.2205, 106.8122],
            [-6.2245, 106.8155],
            [-6.2285, 106.8190]
        ]
    },
    "food-deliver": {
        distance: 5.2,
        duration: 11,
        points: [
            [-6.2285, 106.8190],
            [-6.2205, 106.8122],
            [-6.1973, 106.8231],
            [-6.1754, 106.8272]
        ]
    },
    "health-route": {
        distance: 4.1,
        duration: 8,
        points: [
            [-6.2205, 106.8122],
            [-6.2175, 106.8080],
            [-6.2135, 106.8040]
        ]
    }
};

// --- LEAFLET REAL OPENSTREETMAP ---
let map;
let driverMarker;
let routeLine;
let pickupMarker;
let destMarker;

// Mini-maps for User & Driver simulators
let userMap;
let userDriverMarker;
let userRouteLine;
let userPickupMarker;
let userDestMarker;

let driverMap;
let driverSelfMarker;
let driverRouteLine;
let driverPickupMarker;
let driverDestMarker;

function initLeafletMap() {
    // 1. Center map around Jakarta Sudirman (Admin Map)
    map = L.map('leaflet-map', {
        zoomControl: false,
        attributionControl: false
    }).setView([-6.2205, 106.8122], 13);

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        maxZoom: 19
    }).addTo(map);

    L.control.zoom({
        position: 'bottomright'
    }).addTo(map);

    // Custom glowing driver icon for Admin
    const motorIcon = L.divIcon({
        className: 'custom-motor-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-primary)); transform: scale(1.1); cursor: pointer;">🛵</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });

    driverMarker = L.marker([-6.2085, 106.8227], { icon: motorIcon }).addTo(map);
    driverMarker.bindPopup("<b>Budi Santoso (Driver)</b><br>Status: Online (Mencari Order)").openPopup();

    // 2. Initialize User Phone Mini-Map
    userMap = L.map('user-leaflet-map', {
        zoomControl: false,
        attributionControl: false
    }).setView([-6.2205, 106.8122], 14);

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        maxZoom: 19
    }).addTo(userMap);

    const userDriverIcon = L.divIcon({
        className: 'user-mini-driver',
        html: '<div style="font-size: 20px; filter: drop-shadow(0 0 4px var(--color-primary));">🛵</div>',
        iconSize: [24, 24],
        iconAnchor: [12, 12]
    });
    userDriverMarker = L.marker([-6.2085, 106.8227], { icon: userDriverIcon }).addTo(userMap);

    // 3. Initialize Driver Phone Mini-Map
    driverMap = L.map('driver-leaflet-map', {
        zoomControl: false,
        attributionControl: false
    }).setView([-6.2205, 106.8122], 14);

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        maxZoom: 19
    }).addTo(driverMap);

    const driverSelfIcon = L.divIcon({
        className: 'driver-mini-self',
        html: '<div style="font-size: 20px; filter: drop-shadow(0 0 4px var(--color-indigo));">🏍️</div>',
        iconSize: [24, 24],
        iconAnchor: [12, 12]
    });
    driverSelfMarker = L.marker([-6.2085, 106.8227], { icon: driverSelfIcon }).addTo(driverMap);
}

// --- INITIALIZATION ---
document.addEventListener("DOMContentLoaded", () => {
    updateUIElements();
    calculateRideFareSim(); // Initial calculation
    initLeafletMap(); // Initialize Real OpenStreetMap
    updateCalcFields(); // Initialize interactive calculator fields
    runInteractiveCalculation(); // Run initial pricing calculation
    logToSystem("System ready. Real OpenStreetMap dengan LeafletJS berhasil dimuat.", "success");
    logToSystem("Gunakan sidebar sebelah kiri untuk menavigasi portal.", "info");
});

// --- PORTAL SWAPPING LOGIC ---
function switchPortal(event, portalId) {
    if (event) event.preventDefault();
    
    // Update active nav items
    document.querySelectorAll(".nav-item").forEach(item => {
        item.classList.remove("active");
    });
    const clickedItem = document.querySelector(`[data-target="${portalId}"]`);
    if (clickedItem) clickedItem.classList.add("active");

    // Show/Hide portal sections
    document.querySelectorAll(".portal-section").forEach(sec => {
        sec.classList.remove("active");
    });
    document.getElementById(portalId).classList.add("active");

    // Close sidebar on mobile/tablet view
    if (window.innerWidth <= 991) {
        const sidebar = document.getElementById("sidebar");
        const overlay = document.getElementById("sidebar-overlay");
        if (sidebar && sidebar.classList.contains("active")) {
            sidebar.classList.remove("active");
            overlay.classList.remove("active");
        }
    }

    logToSystem(`Beralih tampilan ke: **${portalId.replace('-portal', '').toUpperCase()} PORTAL**`, "info");
}

// --- LOGGING ENGINE ---
function logToSystem(message, type = "info") {
    const logsContainer = document.getElementById("admin-logs");
    if (!logsContainer) return;

    const time = new Date().toLocaleTimeString('id-ID', { hour12: false });
    const logRow = document.createElement("div");
    logRow.className = `log-row ${type}`;
    logRow.innerHTML = `
        <span class="log-time">[${time}]</span>
        <span class="log-text">${message}</span>
    `;
    logsContainer.prepend(logRow);
}

function clearLogs() {
    const logsContainer = document.getElementById("admin-logs");
    if (logsContainer) logsContainer.innerHTML = "";
    logToSystem("Log aktivitas dibersihkan.", "info");
}

// --- STATE SYNC TO UI ---
function updateUIElements() {
    // Admin Stats
    document.getElementById("admin-stat-drivers-online").innerText = `${state.driversOnline} Driver Online`;
    document.getElementById("admin-stat-revenue").innerText = formatIDR(state.platformRevenue);
    
    // User App View elements
    document.getElementById("user-wallet-balance").innerText = formatIDR(state.userWallet);
    
    // Driver App View elements
    document.getElementById("driver-wallet-disp").innerText = formatIDR(state.driverWallet);
    document.getElementById("driver-completed-orders").innerText = `${state.completedOrders} Selesai`;
    
    // Configurations form values
    document.getElementById("cfg-tariff-per-km").value = state.tariffPerKm;
    document.getElementById("cfg-min-fare").value = state.minFare;
    document.getElementById("cfg-service-fee").value = state.serviceFee;
    document.getElementById("cfg-platform-commission").value = state.platformCommission;
}

function formatIDR(value) {
    return new Intl.NumberFormat("id-ID", {
        style: "currency",
        currency: "IDR",
        maximumFractionDigits: 0
    }).format(value);
}

// --- ADMIN FORM HANDLING ---
function saveTariffSettings(e) {
    e.preventDefault();
    state.tariffPerKm = Number(document.getElementById("cfg-tariff-per-km").value);
    state.minFare = Number(document.getElementById("cfg-min-fare").value);
    state.serviceFee = Number(document.getElementById("cfg-service-fee").value);
    state.platformCommission = Number(document.getElementById("cfg-platform-commission").value);
    
    logToSystem(`Tarif diperbarui: Tarif/KM=Rp${state.tariffPerKm}, Min=Rp${state.minFare}, Biaya Layanan=Rp${state.serviceFee}, Komisi=${state.platformCommission}%`, "success");
    calculateRideFareSim();
    Swal.fire({
        title: 'Konfigurasi Disimpan!',
        text: 'Tarif layanan baru berhasil diperbarui.',
        icon: 'success',
        confirmButtonColor: 'var(--color-indigo)'
    });
}

function approveDriver() {
    document.getElementById("pending-driver-item").classList.add("hidden");
    document.getElementById("no-pending-drivers").classList.remove("hidden");
    state.pendingDrivers = 0;
    state.totalDrivers += 1;
    document.getElementById("admin-stat-drivers").innerText = state.totalDrivers;
    document.getElementById("pending-driver-count").innerText = `0 Pending`;
    document.getElementById("pending-driver-count").className = "badge badge-success";
    logToSystem("Pendaftaran Driver Baru disetujui: **Anto Wijaya** (B 1234 ABC). Berkas Terverifikasi.", "success");
    
    Swal.fire({
        title: 'Driver Disetujui!',
        text: 'Akun driver Anto Wijaya berhasil diaktifkan!',
        icon: 'success',
        confirmButtonColor: 'var(--color-success)'
    });
}

function rejectDriver() {
    document.getElementById("pending-driver-item").classList.add("hidden");
    document.getElementById("no-pending-drivers").classList.remove("hidden");
    state.pendingDrivers = 0;
    document.getElementById("pending-driver-count").innerText = `0 Pending`;
    document.getElementById("pending-driver-count").className = "badge badge-success";
    logToSystem("Registrasi Driver ditolak: **Anto Wijaya** berkas tidak lengkap.", "warning");
}

// --- MOBILE SIMULATOR HELPER ---
function openUserView(viewId) {
    document.querySelectorAll("#user-portal .phone-view").forEach(v => {
        v.classList.remove("active");
    });
    document.getElementById(viewId).classList.add("active");
    
    // Auto refresh Leaflet dimensions when tracking screen mounts
    if (viewId === "user-tracking-view" && userMap) {
        setTimeout(() => {
            userMap.invalidateSize();
        }, 200);
    }
}

function openDriverView(viewId) {
    document.querySelectorAll("#driver-portal .phone-view").forEach(v => {
        v.classList.remove("active");
    });
    document.getElementById(viewId).classList.add("active");
    
    // Auto refresh Leaflet dimensions when navigation screen mounts
    if (viewId === "driver-navigation-view" && driverMap) {
        setTimeout(() => {
            driverMap.invalidateSize();
        }, 200);
    }
}

// --- CALCULATE RIDE FARE VIA OSRM LIVE API ---
async function calculateRideFareSim() {
    const pickup = document.getElementById("user-ride-pickup").value;
    const dest = document.getElementById("user-ride-dest").value;
    
    const distanceEl = document.getElementById("user-ride-distance");
    const durationEl = document.getElementById("user-ride-duration");
    const priceEl = document.getElementById("user-ride-price");
    
    if (pickup === dest) {
        distanceEl.innerText = "0 KM";
        durationEl.innerText = "0 Menit";
        priceEl.innerText = "Rp 0";
        document.getElementById("btn-book-ride").disabled = true;
        return;
    }
    
    document.getElementById("btn-book-ride").disabled = false;
    
    const pickupLoc = LOCATIONS[pickup];
    const destLoc = LOCATIONS[dest];
    
    // Set loading indicator
    distanceEl.innerText = "Menghitung...";
    durationEl.innerText = "Menghitung...";
    
    try {
        const url = `https://router.project-osrm.org/route/v1/driving/${pickupLoc.lng},${pickupLoc.lat};${destLoc.lng},${destLoc.lat}?overview=full&geometries=geojson`;
        const response = await fetch(url);
        const data = await response.json();
        
        let routeDistance, routeDuration, routePoints;
        
        if (data.code === 'Ok' && data.routes && data.routes[0]) {
            const route = data.routes[0];
            routeDistance = parseFloat((route.distance / 1000).toFixed(1)); // Convert to KM
            routeDuration = Math.round(route.duration / 60); // Convert to Minutes
            routePoints = route.geometry.coordinates.map(coord => [coord[1], coord[0]]); // Leaflet uses [lat, lng]
            logToSystem(`OSRM Engine (Live): Rute Sudirman-Monas dihitung secara dinamis. Jarak: ${routeDistance} KM`, "success");
        } else {
            throw new Error("OSRM API response not OK");
        }
        
        // Calculate dynamic fare based on real-time OSRM distance
        const fare = (routeDistance * state.tariffPerKm) + state.minFare + state.serviceFee;
        
        distanceEl.innerText = `${routeDistance} KM`;
        durationEl.innerText = `${routeDuration} Menit`;
        priceEl.innerText = formatIDR(fare);
        
        // Cache active order metadata
        state.activeOrder = {
            type: 'ride',
            pickup: pickup,
            dest: dest,
            distance: routeDistance,
            duration: routeDuration,
            fare: fare,
            routeData: {
                points: routePoints
            }
        };
        
        // Render route preview immediately on real Leaflet map
        setupMapPins(state.activeOrder);
        
    } catch (error) {
        console.warn("Falling back to local simulation route database:", error);
        // Fallback to offline predefined paths if API fails or offline
        const pathKey = `${pickup}-${dest}`;
        const fallbackRoute = ROUTE_PATHS[pathKey] || ROUTE_PATHS["sudirman-monas"];
        
        const fare = (fallbackRoute.distance * state.tariffPerKm) + state.minFare + state.serviceFee;
        distanceEl.innerText = `${fallbackRoute.distance} KM (Local Mode)`;
        durationEl.innerText = `${fallbackRoute.duration} Menit`;
        priceEl.innerText = formatIDR(fare);
        
        state.activeOrder = {
            type: 'ride',
            pickup: pickup,
            dest: dest,
            distance: fallbackRoute.distance,
            duration: fallbackRoute.duration,
            fare: fare,
            routeData: fallbackRoute
        };
        
        setupMapPins(state.activeOrder);
    }
}

// --- RIDE HAILING WORKFLOW SIMULATION ---
function bookRideHailing() {
    if (!state.isDriverOnline || state.isDriverSuspended) {
        Swal.fire({
            title: 'Driver Tidak Tersedia!',
            text: 'Tidak ada driver online yang aktif untuk menerima pesanan Anda. Pastikan driver dalam keadaan online.',
            icon: 'warning',
            confirmButtonColor: 'var(--color-warning)'
        });
        return;
    }
    
    const order = state.activeOrder;
    if (!order) return;
    
    logToSystem(`Order Ride Dibuat: ${LOCATIONS[order.pickup].name} ➡️ ${LOCATIONS[order.dest].name}`, "info");
    logToSystem(`OSRM Engine menghitung rute tercepat: ${order.distance} KM dalam ${order.duration} menit`, "success");
    
    // Switch User screen to tracking mode "Searching Driver"
    openUserView("user-tracking-view");
    document.getElementById("tracking-status-badge").innerText = "MENCARI DRIVER TERDEKAT...";
    document.getElementById("tracking-order-type").innerText = "Ride Hailing (Transportasi)";
    document.getElementById("tracking-order-distance").innerText = `${order.distance} KM`;
    document.getElementById("tracking-order-price").innerText = formatIDR(order.fare);
    
    // Place map pins on the main dashboard
    setupMapPins(order);

    // Simulate driver matching delay of 2.5 seconds
    setTimeout(() => {
        // Trigger Driver App order pop up!
        switchPortal(null, 'driver-portal');
        openDriverView("driver-order-popup-view");
        
        document.getElementById("pop-order-type").innerText = "RIDE HAILING";
        document.getElementById("pop-pickup-loc").innerText = LOCATIONS[order.pickup].name;
        document.getElementById("pop-dest-loc").innerText = LOCATIONS[order.dest].name;
        document.getElementById("pop-distance").innerText = `${order.distance} KM`;
        
        // Clean driver earnings calculation: 80% for driver
        const driverNet = order.fare * (1 - (state.platformCommission / 100));
        document.getElementById("pop-net-fare").innerText = formatIDR(driverNet);
        
        logToSystem(`Sistem mendistribusikan order ke Driver #001 (Budi) - Jarak Jemput 400 meter.`, "info");
    }, 2000);
}

// Map helpers
function setupMapPins(order) {
    const pickupLoc = LOCATIONS[order.pickup];
    const destLoc = LOCATIONS[order.dest];
    
    // Clear old map layers
    if (routeLine) map.removeLayer(routeLine);
    if (pickupMarker) map.removeLayer(pickupMarker);
    if (destMarker) map.removeLayer(destMarker);
    
    const pickupIcon = L.divIcon({
        className: 'pickup-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-success));">🟢</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });
    const destIcon = L.divIcon({
        className: 'dest-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-danger));">📍</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });
    
    pickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], { icon: pickupIcon }).addTo(map)
        .bindPopup(`<b>Jemput:</b> ${pickupLoc.name}`).openPopup();
        
    destMarker = L.marker([destLoc.lat, destLoc.lng], { icon: destIcon }).addTo(map)
        .bindPopup(`<b>Tujuan:</b> ${destLoc.name}`);
        
    routeLine = L.polyline(order.routeData.points, {
        color: 'var(--color-primary)',
        weight: 5,
        opacity: 0.8,
        dashArray: '5, 10',
        lineJoin: 'round'
    }).addTo(map);
    
    map.fitBounds(routeLine.getBounds(), { padding: [50, 50] });
    
    // SINKRONISASI PETA MINI APLIKASI USER
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        if (userPickupMarker) userMap.removeLayer(userPickupMarker);
        if (userDestMarker) userMap.removeLayer(userDestMarker);
        
        userPickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🟢</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(userMap);
        
        userDestMarker = L.marker([destLoc.lat, destLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">📍</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(userMap);
        
        userRouteLine = L.polyline(order.routeData.points, {
            color: 'var(--color-primary)',
            weight: 3,
            opacity: 0.8
        }).addTo(userMap);
        
        userMap.fitBounds(userRouteLine.getBounds(), { padding: [20, 20] });
    }
    
    // Overlay metrics
    document.getElementById("osrm-distance").innerText = `Jarak: ${order.distance} km`;
    document.getElementById("osrm-duration").innerText = `Waktu: ${order.duration} mnt`;
}

function acceptIncomingOrder() {
    const order = state.activeOrder;
    logToSystem("Driver Budi Santoso menerima order. Menuju lokasi penjemputan.", "success");
    
    // Switch Driver screen to Navigating map
    openDriverView("driver-navigation-view");
    document.getElementById("nav-status-desc").innerText = "Menuju Titik Penjemputan";
    document.getElementById("nav-instructions").innerText = `Jemput ${LOCATIONS[order.pickup].name}`;
    document.getElementById("nav-customer-name").innerText = "Davy Pratama";
    
    // Switch user screen state
    document.getElementById("tracking-status-badge").innerText = "DRIVER MENUJU LOKASI JEMPUT 🛵";
    
    // SINKRONISASI PETA MINI DRIVER
    if (driverMap) {
        if (driverRouteLine) driverMap.removeLayer(driverRouteLine);
        if (driverPickupMarker) driverMap.removeLayer(driverPickupMarker);
        if (driverDestMarker) driverMap.removeLayer(driverDestMarker);
        
        const pickupLoc = LOCATIONS[order.pickup];
        const destLoc = LOCATIONS[order.dest];
        
        driverPickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🟢</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(driverMap);
        
        driverDestMarker = L.marker([destLoc.lat, destLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">📍</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(driverMap);
        
        driverRouteLine = L.polyline(order.routeData.points, {
            color: 'var(--color-indigo)',
            weight: 3,
            opacity: 0.8
        }).addTo(driverMap);
        
        driverMap.fitBounds(driverRouteLine.getBounds(), { padding: [20, 20] });
    }
    
    // Start moving the Driver Pin on Real Leaflet Map!
    animateDriverMovement(order.routeData.points, () => {
        logToSystem("Driver telah sampai di lokasi penjemputan. Pelanggan menaiki kendaraan.", "success");
        document.getElementById("tracking-status-badge").innerText = "PERJALANAN SEDANG BERLANGSUNG 🗺️";
        document.getElementById("nav-status-desc").innerText = "Mengantar ke Tujuan";
        document.getElementById("nav-instructions").innerText = `Menuju ${LOCATIONS[order.dest].name}`;
        
        // Next, simulate routing to destination
        animateDriverMovement(order.routeData.points.slice().reverse(), () => {
            logToSystem("Driver sampai di tujuan pengantaran. Selesaikan pembayaran.", "info");
            document.getElementById("tracking-status-badge").innerText = "SAMPAI DI TUJUAN 🏁";
            document.getElementById("btn-complete-trip").disabled = false;
        });
    });
}

function declineIncomingOrder() {
    logToSystem("Driver Budi menolak order. Menghubungi Driver cadangan terdekat...", "warning");
    openDriverView("driver-main-view");
    
    setTimeout(() => {
        Swal.fire({
            title: 'Driver Dialihkan!',
            text: 'Driver Budi sibuk. Sistem mengalihkan pesanan ke driver terdekat lain: Anto Wijaya!',
            icon: 'info',
            confirmButtonColor: 'var(--color-indigo)'
        });
        logToSystem("Driver Anto Wijaya menerima order. Menjemput pelanggan.", "success");
        // Proceed automatically
        acceptIncomingOrder();
    }, 1500);
}

// Animated GPS Tracker Simulator
function animateDriverMovement(points, callback) {
    if (!points || points.length === 0) return;
    
    if (state.simInterval) clearInterval(state.simInterval);
    
    let step = 0;
    const miniPin = document.getElementById("mini-map-driver-pin");
    
    state.simInterval = setInterval(() => {
        if (step >= points.length) {
            clearInterval(state.simInterval);
            state.simInterval = null;
            if (callback) callback();
            return;
        }
        
        const pt = points[step];
        
        // Move major Leaflet driver marker
        if (driverMarker) {
            driverMarker.setLatLng(pt);
            // Center map smoothly around driver
            map.panTo(pt);
        }
        
        // Move User Phone Map driver marker & center map
        if (userDriverMarker && userMap) {
            userDriverMarker.setLatLng(pt);
            userMap.panTo(pt);
        }
        
        // Move Driver Phone Map self marker & center map
        if (driverSelfMarker && driverMap) {
            driverSelfMarker.setLatLng(pt);
            driverMap.panTo(pt);
        }
        
        // Move mini screen mockup map pin (approximate standard lat/lng to 2D percentage box)
        if (miniPin) {
            const latRange = 0.12; // approximate bounding box for Jakarta demo
            const lngRange = 0.12;
            const centerLat = -6.21;
            const centerLng = 106.82;
            
            const pctX = ((pt[1] - (centerLng - lngRange/2)) / lngRange) * 100;
            const pctY = (1 - (pt[0] - (centerLat - latRange/2)) / latRange) * 100;
            
            miniPin.style.left = `${Math.min(Math.max(pctX, 10), 90)}%`;
            miniPin.style.top = `${Math.min(Math.max(pctY, 10), 90)}%`;
        }
        
        step++;
    }, 1500); // 1.5 seconds per waypoint
}

function completeOngoingTrip() {
    const order = state.activeOrder;
    if (!order) return;
    
    // Deduct User Wallet
    state.userWallet -= order.fare;
    
    // Driver Earnings (80%)
    const driverEarnings = order.fare * (1 - (state.platformCommission / 100));
    state.driverWallet += driverEarnings;
    
    // Platform commission (20%)
    const platformShare = order.fare * (state.platformCommission / 100);
    state.platformRevenue += platformShare;
    
    state.completedOrders += 1;
    
    // Save to system
    updateUIElements();
    
    logToSystem(`Trip Selesai! Pembayaran sukses Rp${order.fare}. Komisi Platform Rp${platformShare} ditambahkan.`, "success");
    
    Swal.fire({
        title: 'Transaksi Selesai!',
        html: `<b>Tarif Perjalanan:</b> Rp ${order.fare.toLocaleString('id-ID')}<br>Pembayaran via Go-Pay sukses. Terima kasih!`,
        icon: 'success',
        confirmButtonColor: 'var(--color-success)'
    });
    
    // Reset view states
    openDriverView("driver-main-view");
    openUserView("user-home-view");
    
    // Remove Leaflet map overlays
    if (routeLine) map.removeLayer(routeLine);
    if (pickupMarker) map.removeLayer(pickupMarker);
    if (destMarker) map.removeLayer(destMarker);
    
    // Reset User Phone Map
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        if (userPickupMarker) userMap.removeLayer(userPickupMarker);
        if (userDestMarker) userMap.removeLayer(userDestMarker);
        userMap.setView([-6.2205, 106.8122], 14);
        if (userDriverMarker) userDriverMarker.setLatLng([-6.2085, 106.8227]);
    }
    
    // Reset Driver Phone Map
    if (driverMap) {
        if (driverRouteLine) driverMap.removeLayer(driverRouteLine);
        if (driverPickupMarker) driverMap.removeLayer(driverPickupMarker);
        if (driverDestMarker) driverMap.removeLayer(driverDestMarker);
        driverMap.setView([-6.2205, 106.8122], 14);
        if (driverSelfMarker) driverSelfMarker.setLatLng([-6.2085, 106.8227]);
    }
    
    // Reset driver to default central coordinates
    if (driverMarker) {
        driverMarker.setLatLng([-6.2085, 106.8227]);
        driverMarker.bindPopup("<b>Budi Santoso (Driver)</b><br>Status: Online (Mencari Order)").openPopup();
        map.setView([-6.2205, 106.8122], 13);
    }
    
    state.activeOrder = null;
}

// --- FOOD DELIVERY WORKFLOW SIMULATION ---
let selectedFoodMerchant = "";

function openFoodMerchantDetail(merchantName) {
    selectedFoodMerchant = merchantName;
    Swal.fire({
        title: 'Beralih ke Resto!',
        text: `Membuka Menu Kuliner: ${merchantName}`,
        icon: 'info',
        timer: 1500,
        showConfirmButton: false,
        position: 'center'
    });
    
    // Show cart overlay simulating addition of Ayam Geprek
    document.getElementById("user-food-cart").classList.remove("hidden");
    document.getElementById("cart-item-name").innerText = merchantName === "Bakso Solo Baru" ? "Bakso Solo Istimewa" : "Ayam Geprek Gahar Level 3";
    document.getElementById("cart-item-qty").innerText = merchantName === "Bakso Solo Baru" ? "1 Porsi • Rp 22,000" : "1 Porsi • Rp 18,000";
}

function checkoutFoodOrder() {
    const foodPrice = selectedFoodMerchant === "Bakso Solo Baru" ? 22000 : 18000;
    const deliveryFee = 8000;
    const total = foodPrice + deliveryFee + state.serviceFee;
    
    logToSystem(`User melakukan checkout Makanan dari **${selectedFoodMerchant}** senilai Rp${total}`, "info");
    
    // Hide cart
    document.getElementById("user-food-cart").classList.add("hidden");
    
    // Switch User screen to tracking
    openUserView("user-tracking-view");
    document.getElementById("tracking-status-badge").innerText = "MENUNGGU KONFIRMASI RESTORAN...";
    document.getElementById("tracking-order-type").innerText = `Food Delivery (Pesan Antar)`;
    document.getElementById("tracking-order-distance").innerText = `2.5 KM`;
    document.getElementById("tracking-order-price").innerText = formatIDR(total);
    
    // Draw initial markers on User Phone Map
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        if (userPickupMarker) userMap.removeLayer(userPickupMarker);
        if (userDestMarker) userMap.removeLayer(userDestMarker);
        
        const pickupLoc = LOCATIONS["merchant_food"];
        const destLoc = LOCATIONS["sudirman"];
        
        userPickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🏪</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(userMap);
        
        userDestMarker = L.marker([destLoc.lat, destLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🟢</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(userMap);
        
        userMap.setView([pickupLoc.lat, pickupLoc.lng], 14);
    }
    
    // Cache active order metadata
    state.activeOrder = {
        type: 'food',
        merchantName: selectedFoodMerchant,
        item: selectedFoodMerchant === "Bakso Solo Baru" ? "Bakso Solo Istimewa" : "Ayam Geprek Gahar Level 3",
        fare: total,
        netFare: total - foodPrice,
        price: foodPrice
    };

    // Populate Merchant Food Dashboard queue list!
    const queueList = document.getElementById("merchant-food-orders");
    const noData = document.getElementById("merchant-food-no-orders");
    
    if (noData) noData.classList.add("hidden");
    
    const orderCard = document.createElement("div");
    orderCard.className = "merchant-order-card";
    orderCard.id = "food-merchant-order-card";
    orderCard.innerHTML = `
        <div class="m-order-header flex-between">
            <h4>Pesanan Baru #FD-998</h4>
            <span class="badge badge-warning">Menunggu Konfirmasi</span>
        </div>
        <div class="m-order-items">
            🍔 <strong>${state.activeOrder.item}</strong> (x1)
            <p class="mt-1">Pelanggan: Davy Pratama • Meja/Alamat: Delivery</p>
        </div>
        <button class="btn btn-success btn-sm btn-full" onclick="merchantAcceptFoodOrder(this)">Konfirmasi & Siapkan Pesanan 👨‍🍳</button>
    `;
    queueList.appendChild(orderCard);
    
    document.getElementById("merchant-active-orders-count").innerText = "1 Aktif";
    
    // Automatic alert pop up
    Swal.fire({
        title: 'Pesanan Dikirim!',
        text: "Pesanan makanan sukses dikirim! Sistem akan mengalihkan Anda ke tab 'Merchant Food' untuk memproses pesanan dapur.",
        icon: 'success',
        confirmButtonColor: 'var(--color-success)'
    }).then(() => {
        switchPortal(null, 'merchant-food-portal');
    });
}

function merchantAcceptFoodOrder(btnEl) {
    logToSystem("Merchant menyetujui pesanan. Makanan sedang dimasak dapur...", "success");
    btnEl.innerHTML = "TANDAI SELESAI (SIAP DIANTAR) 📦";
    btnEl.className = "btn btn-primary btn-sm btn-full";
    btnEl.setAttribute("onclick", "merchantCompleteFoodOrder()");
    
    document.getElementById("tracking-status-badge").innerText = "MAKANAN SEDANG DISIAPKAN MERCHANT 👨‍🍳";
}

function merchantCompleteFoodOrder() {
    logToSystem("Merchant selesai memasak. Mencari Driver untuk mengantar makanan...", "success");
    
    document.getElementById("merchant-food-orders").innerHTML = `
        <div class="no-data">Makanan telah diambil oleh Driver. Antrean kosong.</div>
    `;
    document.getElementById("merchant-active-orders-count").innerText = "0 Aktif";
    
    // Trigger Driver Notification
    switchPortal(null, 'driver-portal');
    openDriverView("driver-order-popup-view");
    
    const order = state.activeOrder;
    document.getElementById("pop-order-type").innerText = "FOOD DELIVERY";
    document.getElementById("pop-pickup-loc").innerText = `Ambil: Restoran ${order.merchantName}`;
    document.getElementById("pop-dest-loc").innerText = "Antar: Sudirman Center (User)";
    document.getElementById("pop-distance").innerText = `2.5 KM`;
    
    // Net driver share for food delivery (delivery fee portion + service)
    const driverNet = order.netFare * (1 - (state.platformCommission / 100));
    document.getElementById("pop-net-fare").innerText = formatIDR(driverNet);
    
    // Change acceptance behavior for Food Delivery
    const acceptBtn = document.querySelector("#driver-order-popup-view .btn-success");
    acceptBtn.setAttribute("onclick", "acceptFoodDeliveryDriver()");
}

async function acceptFoodDeliveryDriver() {
    const order = state.activeOrder;
    logToSystem("Driver Budi menerima order pengantaran makanan. Menghubungkan ke OSRM Live...", "info");
    
    openDriverView("driver-navigation-view");
    document.getElementById("nav-status-desc").innerText = "Menghubungkan OSRM...";
    document.getElementById("nav-instructions").innerText = `Mencari rute ke ${order.merchantName}`;
    
    document.getElementById("tracking-status-badge").innerText = "MENGHITUNG RUTE OSRM NYATA... 🗺️";
    
    const pickupLoc = LOCATIONS["merchant_food"];
    const destLoc = LOCATIONS["sudirman"];
    
    let pickupPath = ROUTE_PATHS["food-pickup"].points;
    let deliverPath = ROUTE_PATHS["food-deliver"].points;
    
    try {
        // Fetch OSRM route from Budi's default center (sudirman) to merchant food
        const pickupUrl = `https://router.project-osrm.org/route/v1/driving/${destLoc.lng},${destLoc.lat};${pickupLoc.lng},${pickupLoc.lat}?overview=full&geometries=geojson`;
        const res1 = await fetch(pickupUrl);
        const data1 = await res1.json();
        if (data1.code === 'Ok' && data1.routes?.[0]) {
            pickupPath = data1.routes[0].geometry.coordinates.map(c => [c[1], c[0]]);
        }
        
        // Fetch OSRM route from merchant food to user destination
        const deliverUrl = `https://router.project-osrm.org/route/v1/driving/${pickupLoc.lng},${pickupLoc.lat};${destLoc.lng},${destLoc.lat}?overview=full&geometries=geojson`;
        const res2 = await fetch(deliverUrl);
        const data2 = await res2.json();
        if (data2.code === 'Ok' && data2.routes?.[0]) {
            deliverPath = data2.routes[0].geometry.coordinates.map(c => [c[1], c[0]]);
        }
        
        logToSystem(`OSRM Engine (Live): Rute pengantaran makanan berhasil dihitung secara realtime.`, "success");
    } catch (err) {
        console.warn("Falling back to local food route database:", err);
    }
    
    // Clear old map layers
    if (routeLine) map.removeLayer(routeLine);
    if (pickupMarker) map.removeLayer(pickupMarker);
    if (destMarker) map.removeLayer(destMarker);
    
    const merchIcon = L.divIcon({
        className: 'merchant-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-warning));">🏪</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });
    
    const userIcon = L.divIcon({
        className: 'pickup-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-success));">🟢</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });
    
    pickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], { icon: merchIcon }).addTo(map)
        .bindPopup(`<b>Merchant Resto:</b> ${order.merchantName}`).openPopup();
        
    destMarker = L.marker([destLoc.lat, destLoc.lng], { icon: userIcon }).addTo(map)
        .bindPopup("<b>Alamat Antar:</b> Sudirman Center (Davy)");
        
    // Combine full pickup and deliver path for rendering
    const fullFoodPath = [...pickupPath, ...deliverPath];
    routeLine = L.polyline(fullFoodPath, {
        color: 'var(--color-warning)',
        weight: 5,
        opacity: 0.8,
        dashArray: '5, 10',
        lineJoin: 'round'
    }).addTo(map);
    
    map.fitBounds(routeLine.getBounds(), { padding: [50, 50] });
    
    // SINKRONISASI PETA MINI DRIVER
    if (driverMap) {
        if (driverRouteLine) driverMap.removeLayer(driverRouteLine);
        if (driverPickupMarker) driverMap.removeLayer(driverPickupMarker);
        if (driverDestMarker) driverMap.removeLayer(driverDestMarker);
        
        driverPickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🏪</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(driverMap);
        
        driverDestMarker = L.marker([destLoc.lat, destLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🟢</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(driverMap);
        
        driverRouteLine = L.polyline(fullFoodPath, {
            color: 'var(--color-warning)',
            weight: 3,
            opacity: 0.8
        }).addTo(driverMap);
        
        driverMap.fitBounds(driverRouteLine.getBounds(), { padding: [20, 20] });
    }
    
    // SINKRONISASI PETA MINI USER
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        userRouteLine = L.polyline(fullFoodPath, {
            color: 'var(--color-warning)',
            weight: 3,
            opacity: 0.8
        }).addTo(userMap);
        
        userMap.fitBounds(userRouteLine.getBounds(), { padding: [20, 20] });
    }
    
    // Switch navigation text to pickup
    document.getElementById("nav-status-desc").innerText = "Menuju Restoran Merchant";
    document.getElementById("nav-instructions").innerText = `Ambil pesanan di ${order.merchantName}`;
    document.getElementById("tracking-status-badge").innerText = "DRIVER MENUJU RESTORAN UNTUK AMBIL MAKANAN 🛵";
    
    animateDriverMovement(pickupPath, () => {
        logToSystem("Driver sampai di Restoran. Makanan diambil. Memulai pengantaran ke pelanggan.", "success");
        document.getElementById("tracking-status-badge").innerText = "MAKANAN SEDANG DIANTAR OLEH DRIVER 🛵";
        document.getElementById("nav-status-desc").innerText = "Mengantar Makanan ke Pelanggan";
        document.getElementById("nav-instructions").innerText = "Antar ke Sudirman Center";
        
        animateDriverMovement(deliverPath, () => {
            logToSystem("Driver sampai di rumah pelanggan. Selesaikan pengantaran.", "success");
            document.getElementById("tracking-status-badge").innerText = "PESANAN MAKANAN TIBA DI LOKASI 🏁";
            
            // Reconfigure complete action button
            const completeBtn = document.getElementById("btn-complete-trip");
            completeBtn.setAttribute("onclick", "completeFoodDeliveryTrip()");
            completeBtn.disabled = false;
        });
    });
}

function completeFoodDeliveryTrip() {
    const order = state.activeOrder;
    if (!order) return;
    
    // Deduct user wallet
    state.userWallet -= order.fare;
    
    // Driver Earnings (80% of net delivery fee)
    const driverEarnings = order.netFare * (1 - (state.platformCommission / 100));
    state.driverWallet += driverEarnings;
    
    // Platform Share (20% of net delivery fee)
    const platformShare = order.netFare * (state.platformCommission / 100);
    state.platformRevenue += platformShare;
    
    state.completedOrders += 1;
    
    updateUIElements();
    logToSystem(`Pengantaran Makanan Selesai! E-wallet dipotong Rp${order.fare}. Transaksi tercatat.`, "success");
    Swal.fire({
        title: 'Pesanan Diterima!',
        text: 'Pesanan makanan sukses diterima dan diselesaikan!',
        icon: 'success',
        confirmButtonColor: 'var(--color-success)'
    });
    
    // Reset views
    openDriverView("driver-main-view");
    openUserView("user-home-view");
    
    // Restore button bindings
    document.getElementById("btn-complete-trip").setAttribute("onclick", "completeOngoingTrip()");
    document.querySelector("#driver-order-popup-view .btn-success").setAttribute("onclick", "acceptIncomingOrder()");
    
    // Remove Leaflet map overlays
    if (routeLine) map.removeLayer(routeLine);
    if (pickupMarker) map.removeLayer(pickupMarker);
    if (destMarker) map.removeLayer(destMarker);
    
    // Reset User Phone Map
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        if (userPickupMarker) userMap.removeLayer(userPickupMarker);
        if (userDestMarker) userMap.removeLayer(userDestMarker);
        userMap.setView([-6.2205, 106.8122], 14);
        if (userDriverMarker) userDriverMarker.setLatLng([-6.2085, 106.8227]);
    }
    
    // Reset Driver Phone Map
    if (driverMap) {
        if (driverRouteLine) driverMap.removeLayer(driverRouteLine);
        if (driverPickupMarker) driverMap.removeLayer(driverPickupMarker);
        if (driverDestMarker) driverMap.removeLayer(driverDestMarker);
        driverMap.setView([-6.2205, 106.8122], 14);
        if (driverSelfMarker) driverSelfMarker.setLatLng([-6.2085, 106.8227]);
    }
    
    // Reset driver to default central coordinates
    if (driverMarker) {
        driverMarker.setLatLng([-6.2085, 106.8227]);
        driverMarker.bindPopup("<b>Budi Santoso (Driver)</b><br>Status: Online (Mencari Order)").openPopup();
        map.setView([-6.2205, 106.8122], 13);
    }
    
    state.activeOrder = null;
}

// --- GO HEALTH VIEW FLOWS ---
function openApotekCatalog() {
    document.getElementById("pharmacy-catalog-section").classList.remove("hidden");
}

function selectMedicineItem() {
    document.getElementById("med-item-card").classList.remove("hidden");
}

function checkoutHealthOrder() {
    const medicinePrice = 35000;
    const delivery = 8000;
    const total = medicinePrice + delivery + state.serviceFee;
    
    logToSystem(`User memesan Obat Multivitamin Booster dari Apotek Kimia Farma senilai Rp${total}`, "info");
    
    openUserView("user-tracking-view");
    document.getElementById("tracking-status-badge").innerText = "RESEP DIKONFIRMASI APOTEKER...";
    document.getElementById("tracking-order-type").innerText = "Layanan Kesehatan (Health)";
    document.getElementById("tracking-order-distance").innerText = "3.2 KM";
    document.getElementById("tracking-order-price").innerText = formatIDR(total);
    
    // Draw initial markers on User Phone Map
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        if (userPickupMarker) userMap.removeLayer(userPickupMarker);
        if (userDestMarker) userMap.removeLayer(userDestMarker);
        
        const pickupLoc = LOCATIONS["merchant_health"];
        const destLoc = LOCATIONS["sudirman"];
        
        userPickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🏥</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(userMap);
        
        userDestMarker = L.marker([destLoc.lat, destLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🟢</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(userMap);
        
        userMap.setView([pickupLoc.lat, pickupLoc.lng], 14);
    }
    
    // Populating Merchant Health Queue
    const noData = document.getElementById("merchant-health-no-orders");
    if (noData) noData.classList.add("hidden");
    
    const queue = document.getElementById("merchant-health-orders");
    const healthCard = document.createElement("div");
    healthCard.className = "merchant-order-card";
    healthCard.innerHTML = `
        <div class="m-order-header flex-between">
            <h4>Apotek Order #MD-112</h4>
            <span class="badge badge-success">Diverifikasi Apoteker</span>
        </div>
        <div class="m-order-items">
            💊 <strong>Multivitamin Booster C+ (x1)</strong>
            <p>Pasien: Davy Pratama • Kirim via Kurir Go-Super</p>
        </div>
        <button class="btn btn-success btn-sm btn-full" onclick="Swal.fire({title: 'Sedang Dikemas!', text: 'Obat sedang dikemas oleh Apoteker. Kurir terdekat sedang ditugaskan.', icon: 'info', confirmButtonColor: 'var(--color-success)'}).then(() => processHealthDriverDelivery('${total}', '${total - medicinePrice}'))">Siapkan & Cari Kurir 🛵</button>
    `;
    queue.appendChild(healthCard);
    document.getElementById("merchant-health-orders-count").innerText = "1 Aktif";
    
    Swal.fire({
        title: 'Pesanan Dikirim!',
        text: "Pesanan obat berhasil dikirim ke Apotik Mitra! Sistem otomatis mengalihkan ke tab 'Merchant Health' untuk memproses obat.",
        icon: 'success',
        confirmButtonColor: 'var(--color-success)'
    }).then(() => {
        switchPortal(null, 'merchant-health-portal');
    });
}

function processHealthDriverDelivery(total, netFare) {
    document.getElementById("merchant-health-orders").innerHTML = `
        <div class="no-data">Pesanan obat telah diserahkan ke Driver.</div>
    `;
    document.getElementById("merchant-health-orders-count").innerText = "0 Aktif";
    
    state.activeOrder = {
        type: 'health',
        item: 'Multivitamin Booster C+',
        fare: Number(total),
        netFare: Number(netFare)
    };
    
    // Assign to Driver App
    switchPortal(null, 'driver-portal');
    openDriverView("driver-order-popup-view");
    
    document.getElementById("pop-order-type").innerText = "HEALTH DELIVERY";
    document.getElementById("pop-pickup-loc").innerText = "Ambil: Apotek Kimia Farma Sudirman";
    document.getElementById("pop-dest-loc").innerText = "Antar: Sudirman Center (Pasien)";
    document.getElementById("pop-distance").innerText = "3.2 KM";
    
    const driverNet = netFare * (1 - (state.platformCommission / 100));
    document.getElementById("pop-net-fare").innerText = formatIDR(driverNet);
    
    // Change driver accept trigger
    document.querySelector("#driver-order-popup-view .btn-success").setAttribute("onclick", "acceptHealthDeliveryDriver()");
}

async function acceptHealthDeliveryDriver() {
    logToSystem("Driver menerima order pengantaran Obat/Vitamin Go-Health. Menghubungkan ke OSRM Live...", "info");
    openDriverView("driver-navigation-view");
    document.getElementById("nav-status-desc").innerText = "Menghubungkan OSRM...";
    document.getElementById("nav-instructions").innerText = "Mencari apotik terdekat...";
    
    document.getElementById("tracking-status-badge").innerText = "MENGHITUNG RUTE OSRM NYATA... 💊";
    
    const pickupLoc = LOCATIONS["merchant_health"];
    const destLoc = LOCATIONS["sudirman"];
    
    let healthPath = ROUTE_PATHS["health-route"].points;
    
    try {
        const url = `https://router.project-osrm.org/route/v1/driving/${pickupLoc.lng},${pickupLoc.lat};${destLoc.lng},${destLoc.lat}?overview=full&geometries=geojson`;
        const res = await fetch(url);
        const data = await res.json();
        if (data.code === 'Ok' && data.routes?.[0]) {
            healthPath = data.routes[0].geometry.coordinates.map(c => [c[1], c[0]]);
            logToSystem(`OSRM Engine (Live): Rute pengantaran obat berhasil dihitung secara dinamis.`, "success");
        }
    } catch (err) {
        console.warn("Falling back to local health route database:", err);
    }
    
    // Clear old map layers
    if (routeLine) map.removeLayer(routeLine);
    if (pickupMarker) map.removeLayer(pickupMarker);
    if (destMarker) map.removeLayer(destMarker);
    
    const pharmacyIcon = L.divIcon({
        className: 'pharmacy-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-success));">🏥</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });
    
    const userIcon = L.divIcon({
        className: 'pickup-marker',
        html: '<div style="font-size: 24px; filter: drop-shadow(0 0 6px var(--color-success));">🟢</div>',
        iconSize: [30, 30],
        iconAnchor: [15, 15]
    });
    
    pickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], { icon: pharmacyIcon }).addTo(map)
        .bindPopup("<b>Apotek:</b> Kimia Farma Benhil").openPopup();
        
    destMarker = L.marker([destLoc.lat, destLoc.lng], { icon: userIcon }).addTo(map)
        .bindPopup("<b>Pasien:</b> Davy Pratama (Sudirman)");
        
    routeLine = L.polyline(healthPath, {
        color: 'var(--color-success)',
        weight: 5,
        opacity: 0.8,
        dashArray: '5, 10',
        lineJoin: 'round'
    }).addTo(map);
    
    map.fitBounds(routeLine.getBounds(), { padding: [50, 50] });
    
    // SINKRONISASI PETA MINI DRIVER
    if (driverMap) {
        if (driverRouteLine) driverMap.removeLayer(driverRouteLine);
        if (driverPickupMarker) driverMap.removeLayer(driverPickupMarker);
        if (driverDestMarker) driverMap.removeLayer(driverDestMarker);
        
        driverPickupMarker = L.marker([pickupLoc.lat, pickupLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🏥</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(driverMap);
        
        driverDestMarker = L.marker([destLoc.lat, destLoc.lng], {
            icon: L.divIcon({
                html: '<div style="font-size: 16px;">🟢</div>',
                iconSize: [20, 20],
                iconAnchor: [10, 10]
            })
        }).addTo(driverMap);
        
        driverRouteLine = L.polyline(healthPath, {
            color: 'var(--color-success)',
            weight: 3,
            opacity: 0.8
        }).addTo(driverMap);
        
        driverMap.fitBounds(driverRouteLine.getBounds(), { padding: [20, 20] });
    }
    
    // SINKRONISASI PETA MINI USER
    if (userMap) {
        if (userRouteLine) userMap.removeLayer(userRouteLine);
        userRouteLine = L.polyline(healthPath, {
            color: 'var(--color-success)',
            weight: 3,
            opacity: 0.8
        }).addTo(userMap);
        
        userMap.fitBounds(userRouteLine.getBounds(), { padding: [20, 20] });
    }
    
    document.getElementById("nav-status-desc").innerText = "Menuju Apotek Mitra";
    document.getElementById("nav-instructions").innerText = "Ambil obat di Apotek Kimia Farma";
    document.getElementById("tracking-status-badge").innerText = "DRIVER MENGAMBIL OBAT DI APOTEK 💊";
    
    animateDriverMovement(healthPath, () => {
        logToSystem("Driver telah mengambil resep dan sedang mengantar obat ke pasien.", "success");
        document.getElementById("tracking-status-badge").innerText = "OBAT SEDANG DIANTAR OLEH DRIVER 🛵";
        document.getElementById("nav-status-desc").innerText = "Mengantar Paket Obat ke Pelanggan";
        document.getElementById("nav-instructions").innerText = "Antar ke Sudirman Center";
        
        animateDriverMovement(healthPath.slice().reverse(), () => {
            logToSystem("Driver sampai di rumah pasien. Transaksi selesai.", "success");
            document.getElementById("tracking-status-badge").innerText = "OBAT DITERIMA PASIEN 🏁";
            
            const completeBtn = document.getElementById("btn-complete-trip");
            completeBtn.setAttribute("onclick", "completeFoodDeliveryTrip()"); // reuse generic food share logic
            completeBtn.disabled = false;
        });
    });
}

function openClinicBooking() {
    Swal.fire({
        title: 'Booking Layanan Klinik',
        html: `<div style="text-align: left; line-height: 1.6;">
            <b>Alur Booking Layanan Kesehatan:</b><br>
            1. Pilih Poli Klinik (Klinik Gigi / Umum)<br>
            2. Tentukan Tanggal & Jam Konsultasi<br>
            3. Driver Go-Super akan otomatis menjemput 30 menit sebelum jadwal konsultasi dimulai.
        </div>`,
        icon: 'info',
        confirmButtonText: 'Jadwalkan Sekarang',
        confirmButtonColor: 'var(--color-success)'
    }).then((result) => {
        if (result.isConfirmed) {
            logToSystem("Booking Klinik Umum berhasil terjadwal untuk besok pagi.", "success");
            Swal.fire({
                title: 'Berhasil Terjadwal!',
                text: 'Konsultasi klinik umum berhasil dijadwalkan.',
                icon: 'success',
                confirmButtonColor: 'var(--color-success)'
            });
        }
    });
}

// --- GLOBAL SIMULATION TRIGGERS ---
function startRideHailingSimulation() {
    logToSystem("=== MEMULAI SIMULASI OTOMATIS: RIDE HAILING ===", "info");
    switchPortal(null, 'user-portal');
    openUserView('user-ride-view');
    document.getElementById("user-ride-pickup").value = "sudirman";
    document.getElementById("user-ride-dest").value = "monas";
    calculateRideFareSim();
    
    setTimeout(() => {
        bookRideHailing();
    }, 1500);
}

function startFoodDeliverySimulation() {
    logToSystem("=== MEMULAI SIMULASI OTOMATIS: FOOD DELIVERY ===", "info");
    switchPortal(null, 'user-portal');
    openUserView('user-food-view');
    
    setTimeout(() => {
        openFoodMerchantDetail("Ayam Geprek Gahar");
        setTimeout(() => {
            checkoutFoodOrder();
        }, 1500);
    }, 1000);
}

// --- ANTI-FRAUD / ANTI FAKE GPS SECURITY SIMULATION ---
function triggerGpsFraudSimulation() {
    logToSystem("=== SISTEM KEAMANAN MENDETEKSI ANOMALI GPS DRIVER ===", "danger");
    
    // Trigger global red alert bar
    const alertBar = document.getElementById("alert-bar");
    const alertMsg = document.getElementById("alert-message");
    
    alertMsg.innerHTML = `<strong>🚨 PERINGATAN KEAMANAN:</strong> Driver #001 (Budi Santoso) terdeteksi menggunakan aplikasi GPS Palsu (Mock Location Provider) di koordinat (-6.2088, 106.8456). Akun ditangguhkan otomatis oleh sistem.`;
    alertBar.classList.remove("hidden");
    
    // Mark driver suspended in state
    state.isDriverOnline = false;
    state.isDriverSuspended = true;
    state.driversOnline -= 1;
    
    // Update Admin dashboard logs and stats
    logToSystem("Sistem Anti Fake GPS mendeteksi flag 'isFromMockProvider' bernilai true pada aplikasi Driver Budi.", "danger");
    logToSystem("Akun Driver Budi Santoso disuspend otomatis. Status diubah menjadi OFFLINE.", "danger");
    
    updateUIElements();

    // Adjust Driver Portal UI to reflect suspension
    switchPortal(null, 'driver-portal');
    document.getElementById("driver-status-toggle").checked = false;
    document.getElementById("driver-status-toggle").disabled = true;
    document.getElementById("driver-status-text").innerText = "DITANGGUHKAN (SUSPENDED)";
    document.getElementById("driver-status-text").className = "status-text-label text-danger";
    
    document.querySelector(".driver-profile-header .badge").innerText = "DITANGGUHKAN 🚫";
    document.querySelector(".driver-profile-header .badge").className = "badge badge-danger";
    
    // Show alert pop up
    alert("SISTEM ANTI-FRAUD AKTIF!\n\nDriver terdeteksi menggunakan fake GPS. Akun disuspend secara otomatis oleh server backend dan tidak bisa menerima order.");
}

function closeAlert() {
    document.getElementById("alert-bar").classList.add("hidden");
}

// --- RESET SIMULATION ---
function resetSimulation() {
    if (confirm("Apakah Anda ingin me-reset status simulator ke kondisi awal?")) {
        // Stop current animation intervals
        clearInterval(state.simInterval);
        
        state = {
            userWallet: 150000,
            driverWallet: 120000,
            platformRevenue: 48250000,
            driversOnline: 245,
            totalDrivers: 1840,
            completedOrders: 6,
            pendingDrivers: 1,
            isDriverOnline: true,
            isDriverSuspended: false,
            tariffPerKm: 2500,
            minFare: 8000,
            serviceFee: 2000,
            platformCommission: 20,
            activeOrder: null
        };
        
        // Reset Admin Document Verifications
        document.getElementById("pending-driver-item").classList.remove("hidden");
        document.getElementById("no-pending-drivers").classList.add("hidden");
        document.getElementById("pending-driver-count").innerText = `1 Pending`;
        document.getElementById("pending-driver-count").className = "badge badge-warning";
        document.getElementById("admin-stat-drivers").innerText = "1,840";
        
        // Reset Map SVG elements
        document.getElementById("map-pin-user").classList.add("hidden");
        document.getElementById("map-pin-dest").classList.add("hidden");
        document.getElementById("map-route-path").classList.add("hidden");
        document.getElementById("map-pin-driver").setAttribute("transform", "translate(100, 200)");
        document.getElementById("map-driver-label").innerText = "Driver A (Mencari Order)";
        
        // Reset user phone view
        openUserView("user-home-view");
        
        // Reset driver phone view
        openDriverView("driver-main-view");
        document.getElementById("driver-status-toggle").checked = true;
        document.getElementById("driver-status-toggle").disabled = false;
        document.getElementById("driver-status-text").innerText = "ONLINE";
        document.getElementById("driver-status-text").className = "status-text-label text-success";
        document.querySelector(".driver-profile-header .badge").innerText = "Akun Aktif (Verified)";
        document.querySelector(".driver-profile-header .badge").className = "badge badge-success";
        
        // Reset Food and Health queues
        document.getElementById("merchant-food-orders").innerHTML = `
            <div class="no-data" id="merchant-food-no-orders">Belum ada pesanan aktif dari pelanggan saat ini.</div>
        `;
        document.getElementById("merchant-active-orders-count").innerText = "0 Aktif";
        
        document.getElementById("merchant-health-orders").innerHTML = `
            <div class="no-data" id="merchant-health-no-orders">Belum ada pesanan apotek atau booking klinik aktif.</div>
        `;
        document.getElementById("merchant-health-orders-count").innerText = "0 Aktif";
        
        // Restore buttons
        document.getElementById("btn-complete-trip").setAttribute("onclick", "completeOngoingTrip()");
        document.querySelector("#driver-order-popup-view .btn-success").setAttribute("onclick", "acceptIncomingOrder()");
        
        // Update stats
        updateUIElements();
        closeAlert();
        clearLogs();
        logToSystem("Simulator berhasil direset ke kondisi default.", "info");
        
        switchPortal(null, 'admin-portal');
    }
}

// --- E-WALLET TOP UP SIMULATOR ---
function topupWallet() {
    const amount = prompt("Masukkan jumlah nominal Top Up e-wallet Go-Pay Anda (IDR):", "50000");
    if (amount) {
        const amtNum = Number(amount);
        if (isNaN(amtNum) || amtNum <= 0) {
            alert("Jumlah nominal tidak valid!");
            return;
        }
        state.userWallet += amtNum;
        updateUIElements();
        logToSystem(`User berhasil melakukan Top Up e-wallet Go-Pay sebesar Rp${amtNum}.`, "success");
        alert(`Top Up Sukses!\nSaldo Go-Pay bertambah ${formatIDR(amtNum)}`);
    }
}

// --- OSRM GIS PORTAL ACTIONS ---

// LUA Profile codes
const LUA_PROFILES = {
    motorcycle: `-- Profile Kustom OSRM Go-Super
-- Menentukan kecepatan dan akses jalan untuk MOTOR
local find_access_tag = require("lib/access")

function limit_speed(way, speed)
    local width = way:get_value_by_key("width")
    local highway = way:get_value_by_key("highway")
    
    -- Logika untuk motor: Bisa lewat gang sempit (lebar < 2m)
    if width and tonumber(width) < 2.0 then
        if highway == "service" or highway == "alley" or highway == "residential" then
            speed = 15 -- Kecepatan lambat di gang: 15 km/jam
        else
            speed = 0  -- Jalan sempit tidak boleh diakses jenis lain
        end
    end
    return speed
end

function process_way(profile, way, result)
    local highway = way:get_value_by_key("highway")
    local speed = 40 -- Kecepatan standar 40 km/jam
    
    if highway == "motorway" then
        speed = 40 -- Motor dibatasi di jalan tol
    elseif highway == "trunk" or highway == "primary" then
        speed = 50
    elseif highway == "residential" then
        speed = 30
    elseif highway == "service" or highway == "alley" then
        speed = 25 -- Kecepatan motor stabil lewat gang sempit
    end
    
    result.forward_speed = limit_speed(way, speed)
    result.backward_speed = limit_speed(way, speed)
end`,

    car: `-- Profile Kustom OSRM Go-Super
-- Menentukan kecepatan dan akses jalan untuk MOBIL (CAR)
local find_access_tag = require("lib/access")

function limit_speed(way, speed)
    local width = way:get_value_by_key("width")
    local highway = way:get_value_by_key("highway")
    
    -- Logika untuk Mobil: Tidak bisa masuk gang sempit (lebar < 2.2m)
    if width and tonumber(width) < 2.2 then
        speed = 0 -- Blokir akses mobil masuk gang
    end
    
    -- Jalan sempit berupa alley juga dilarang masuk
    if highway == "alley" or highway == "footway" then
        speed = 0
    end
    return speed
end

function process_way(profile, way, result)
    local highway = way:get_value_by_key("highway")
    local speed = 60 -- Kecepatan mobil standar 60 km/jam
    
    if highway == "motorway" then
        speed = 100 -- Mobil diperbolehkan kecepatan tinggi di Tol: 100 km/jam
    elseif highway == "trunk" or highway == "primary" then
        speed = 70
    elseif highway == "residential" then
        speed = 40
    elseif highway == "service" then
        speed = 20
    elseif highway == "alley" then
        speed = 0 -- Jalan tikus diblokir penuh
    end
    
    result.forward_speed = limit_speed(way, speed)
    result.backward_speed = limit_speed(way, speed)
end`
};

function changeLuaProfile() {
    const selector = document.getElementById("lua-profile-selector");
    const textarea = document.getElementById("lua-code-textarea");
    const val = selector.value;
    
    textarea.value = LUA_PROFILES[val];
    
    // Update performance monitor method and metadata
    const ramFill = document.getElementById("osrm-ram-fill");
    const ramIndicator = document.getElementById("osrm-ram-indicator");
    const methodLabel = document.getElementById("osrm-method-label");
    
    if (val === 'car') {
        methodLabel.innerText = "MLD (Multi-Level Dijkstra)";
        ramIndicator.innerText = "1.8 GB / 8.0 GB";
        ramFill.style.width = "22.5%";
        logToSystem("Profil LUA diubah ke: **MOBIL (CAR)**. Jalan tol diaktifkan penuh (100km/jam), gang sempit/alley diblokir otomatis dari rute.", "warning");
    } else {
        methodLabel.innerText = "CH (Contraction Hierarchies)";
        ramIndicator.innerText = "1.2 GB / 8.0 GB";
        ramFill.style.width = "15%";
        logToSystem("Profil LUA diubah ke: **MOTORCYCLE**. Akses gang sempit/jalan tikus diperbolehkan, kecepatan jalan tol disesuaikan.", "success");
    }
}

function saveLuaProfileScript() {
    const selector = document.getElementById("lua-profile-selector").value;
    logToSystem(`Skrip LUA \`profile.lua\` berhasil disimpan oleh admin untuk profil **${selector.toUpperCase()}**.`, "success");
    logToSystem("Sistem backend mempersiapkan reloading container OSRM backend.", "info");
    alert("Profil LUA berhasil disimpan!\n\nLangkah selanjutnya silakan klik tombol 'Jalankan Pipeline OSRM' untuk mengompilasi ulang graf peta dengan profil LUA baru ini.");
}

// OSRM Compiler Simulator with timed delays for a premium experience
function runOsmPipelineSimulator() {
    const terminal = document.getElementById("osrm-compiler-terminal");
    const ramIndicator = document.getElementById("osrm-ram-indicator");
    const ramFill = document.getElementById("osrm-ram-fill");
    
    terminal.innerHTML = "";
    logToSystem("Memulai proses kompilasi data OpenStreetMap OSRM Pipeline...", "info");
    
    const lines = [
        { text: "$ osrm-extract -p profile.lua indonesia-latest.osm.pbf", color: "#ffffff", delay: 0 },
        { text: "[info] Input file: indonesia-latest.osm.pbf (Size: 450MB)", color: "#9ca3af", delay: 800 },
        { text: "[info] Profile: profile.lua", color: "#9ca3af", delay: 1300 },
        { text: "[info] Threads: 8 CPU Cores allocated", color: "#9ca3af", delay: 1800 },
        { text: "[info] Parsing in progress...", color: "#9ca3af", delay: 2400 },
        { text: "[info] Processing 82,450,128 nodes...", color: "#eab308", delay: 3200 },
        { text: "[info] Processing 6,120,490 ways...", color: "#eab308", delay: 4200 },
        { text: "[info] Processing 12,410 relations...", color: "#eab308", delay: 5000 },
        { text: "[info] Completed parsing OSM dataset nodes and tags.", color: "#10b981", delay: 5800 },
        { text: "[info] Compressing topology and writing index (.osrm)...", color: "#9ca3af", delay: 6500 },
        { text: "", color: "#ffffff", delay: 7000 },
        { text: "$ osrm-partition indonesia-latest.osrm", color: "#ffffff", delay: 7200 },
        { text: "[info] Partitioning cell blocks for Multi-Level Dijkstra (MLD)...", color: "#9ca3af", delay: 8000 },
        { text: "[info] Partitioned dataset into 4 levels, 256 sub-cells.", color: "#10b981", delay: 8800 },
        { text: "", color: "#ffffff", delay: 9200 },
        { text: "$ osrm-customize indonesia-latest.osrm", color: "#ffffff", delay: 9400 },
        { text: "[info] Customizing speed metrics and LUA cell weights...", color: "#9ca3af", delay: 10200 },
        { text: "[info] OSRM Graph successfully compiled! Final File: indonesia-latest.osrm (Size: 240MB)", color: "#10b981", delay: 11000 },
        { text: "", color: "#ffffff", delay: 11300 },
        { text: "$ docker restart osrm-backend-indonesia", color: "#ffffff", delay: 11500 },
        { text: "[info] Restarting container...", color: "#9ca3af", delay: 12200 },
        { text: "[info] Docker container successfully restarted! Running on Port 5000.", color: "#10b981", delay: 13000 },
        { text: "SUCCESS: OSRM engine successfully reloaded with new LUA speed profiles!", color: "#22c55e", font: "bold", delay: 13500 }
    ];
    
    // Simulate RAM spikes during processing
    setTimeout(() => {
        ramIndicator.innerText = "5.8 GB / 8.0 GB (High Pipeline Load)";
        ramFill.style.width = "72.5%";
        ramFill.style.backgroundColor = "var(--color-warning)";
    }, 3000);
    
    setTimeout(() => {
        ramIndicator.innerText = "7.2 GB / 8.0 GB (Customizer Sorting)";
        ramFill.style.width = "90%";
        ramFill.style.backgroundColor = "var(--color-danger)";
    }, 9500);
    
    setTimeout(() => {
        ramIndicator.innerText = "1.2 GB / 8.0 GB (Optimized Idle)";
        ramFill.style.width = "15%";
        ramFill.style.backgroundColor = "var(--color-success)";
    }, 13200);

    // Render terminal outputs
    lines.forEach(line => {
        setTimeout(() => {
            const row = document.createElement("div");
            row.style.color = line.color;
            if (line.font === 'bold') {
                row.style.fontWeight = 'bold';
                row.style.fontSize = '13px';
                row.style.marginTop = '8px';
            }
            row.innerText = line.text;
            terminal.appendChild(row);
            terminal.scrollTop = terminal.scrollHeight;
            
            if (line.text.startsWith("SUCCESS")) {
                logToSystem("Pipeline data OSRM sukses dijalankan. Indonesia OSM PBF berhasil diekstrak dan OSRM backend dimuat ulang dalam Docker.", "success");
                alert("Pipeline OSRM Sukses!\n\nSeluruh data peta Indonesia telah diperbarui menggunakan custom profile LUA.");
            }
        }, line.delay);
    });
}

function sendMockDistanceMatrixRequest() {
    const responsePre = document.getElementById("matrix-response-json");
    responsePre.innerText = "Mengirim HTTP POST request ke /table/v1/motorcycle...";
    
    const selector = document.getElementById("lua-profile-selector").value;
    
    logToSystem(`Distance Matrix API dipanggil via HTTP POST dengan profil LUA: **${selector.toUpperCase()}**`, "info");
    
    // Simulate API delay
    setTimeout(() => {
        const matrixOutput = {
            "code": "Ok",
            "durations": [
                [0, 900, 1320],
                [900, 0, 2220],
                [1320, 2220, 0]
            ],
            "distances": [
                [0, 8200, 12400],
                [8200, 0, 18200],
                [12400, 18200, 0]
            ],
            "destinations": [
                { "hint": "4tQDg...", "distance": 4.2, "name": "Sudirman Center", "location": [106.8456, -6.2088] },
                { "hint": "12_Xg...", "distance": 1.8, "name": "Monas Park", "location": [106.8272, -6.1754] },
                { "hint": "9a_Pg...", "distance": 8.5, "name": "Kemang Square", "location": [106.8150, -6.2510] }
            ],
            "sources": [
                { "hint": "4tQDg...", "distance": 4.2, "name": "Sudirman Center", "location": [106.8456, -6.2088] }
            ]
        };
        
        responsePre.innerText = JSON.stringify(matrixOutput, null, 2);
        logToSystem(`OSRM API mengembalikan NxN Distance Matrix sukses: 3 sumber, 3 tujuan terhitung.`, "success");
    }, 1200);
}

function setViewMode(mode) {
    const focusBtn = document.getElementById("btn-focus-mode");
    const multiBtn = document.getElementById("btn-multi-mode");
    
    if (mode === 'multi') {
        document.body.classList.add("multi-window-mode");
        
        focusBtn.className = "btn btn-sm btn-outline";
        multiBtn.className = "btn btn-sm btn-primary";
        
        logToSystem("=== MENGAKTIFKAN MODE EKOSISTEM LIVE MULTI-WINDOW (5 APLIKASI SINKRON) ===", "info");
        logToSystem("Seluruh portal aktif dan ditampilkan side-by-side secara realtime di layar.", "success");
    } else {
        document.body.classList.remove("multi-window-mode");
        
        focusBtn.className = "btn btn-sm btn-primary";
        multiBtn.className = "btn btn-sm btn-outline";
        
        logToSystem("=== MENGAKTIFKAN MODE FOKUS TAB ===", "info");
        
        // Restore tab state visibility
        const sections = document.querySelectorAll(".portal-section");
        sections.forEach(sec => {
            sec.classList.remove("active");
        });
        
        const activeNav = document.querySelector(".nav-item.active");
        if (activeNav) {
            const target = activeNav.getAttribute("data-target");
            const targetSec = document.getElementById(target);
            if (targetSec) targetSec.classList.add("active");
        } else {
            document.getElementById("admin-portal").classList.add("active");
        }
    }
}

// --- INTERACTIVE PRICING CALCULATOR ---
function updateCalcFields() {
    const serviceType = document.getElementById("calc-service-type").value;
    const groupDistance = document.getElementById("group-calc-distance");
    const groupTariff = document.getElementById("group-calc-tariff");
    const groupMinfare = document.getElementById("group-calc-minfare");
    const groupProductPrice = document.getElementById("group-calc-product-price");
    const rowMerchant = document.getElementById("row-calc-merchant");
    const legendMerchant = document.getElementById("legend-calc-merchant");
    
    if (serviceType === 'ride') {
        groupDistance.style.display = "block";
        groupTariff.style.display = "block";
        groupMinfare.style.display = "block";
        groupProductPrice.style.display = "none";
        rowMerchant.style.display = "none";
        legendMerchant.style.display = "none";
    } else {
        // Food or Health
        groupDistance.style.display = "none";
        groupTariff.style.display = "none";
        groupMinfare.style.display = "none";
        groupProductPrice.style.display = "block";
        rowMerchant.style.display = "flex";
        legendMerchant.style.display = "flex";
    }
    runInteractiveCalculation();
}

function runInteractiveCalculation() {
    const serviceType = document.getElementById("calc-service-type").value;
    const platformCommission = Number(document.getElementById("calc-platform-commission").value) || 0;
    const serviceFee = Number(document.getElementById("calc-service-fee").value) || 0;
    
    let total = 0;
    let driverShare = 0;
    let platformShare = 0;
    let merchantShare = 0;
    
    if (serviceType === 'ride') {
        const distance = parseFloat(document.getElementById("calc-distance").value);
        document.getElementById("val-calc-distance").innerText = `${distance.toFixed(1)} KM`;
        const tariffPerKm = Number(document.getElementById("calc-tariff-per-km").value) || 0;
        const minFare = Number(document.getElementById("calc-min-fare").value) || 0;
        
        total = (distance * tariffPerKm) + minFare + serviceFee;
        
        platformShare = total * (platformCommission / 100);
        driverShare = total - platformShare;
        merchantShare = 0;
    } else {
        // Food or Health
        const productPrice = Number(document.getElementById("calc-product-price").value) || 0;
        const deliveryFee = 8000; // standard flat delivery fee
        
        total = productPrice + deliveryFee + serviceFee;
        
        const netDelivery = deliveryFee + serviceFee;
        platformShare = netDelivery * (platformCommission / 100);
        driverShare = netDelivery - platformShare;
        merchantShare = productPrice;
    }
    
    // Update labels
    document.getElementById("out-calc-total").innerText = formatIDR(total);
    document.getElementById("out-calc-driver").innerText = formatIDR(driverShare);
    document.getElementById("out-calc-platform").innerText = formatIDR(platformShare);
    document.getElementById("out-calc-merchant").innerText = formatIDR(merchantShare);
    
    // Update breakdown bar
    const barDriver = document.getElementById("bar-calc-driver");
    const barPlatform = document.getElementById("bar-calc-platform");
    const barMerchant = document.getElementById("bar-calc-merchant");
    
    if (total > 0) {
        const pctDriver = (driverShare / total) * 100;
        const pctPlatform = (platformShare / total) * 100;
        const pctMerchant = (merchantShare / total) * 100;
        
        barDriver.style.width = `${pctDriver}%`;
        barPlatform.style.width = `${pctPlatform}%`;
        barMerchant.style.width = `${pctMerchant}%`;
    } else {
        barDriver.style.width = "0%";
        barPlatform.style.width = "0%";
        barMerchant.style.width = "0%";
    }
}

// --- MOBILE SIDEBAR TOGGLER ---
function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebar-overlay");
    if (sidebar && overlay) {
        sidebar.classList.toggle("active");
        overlay.classList.toggle("active");
    }
}


