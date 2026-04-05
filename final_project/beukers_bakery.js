const products = [
  {
    name: "Baguette",
    stub: "baguette",
    imgSrc: "images/baguettes.jpg",
    imgAlt: "Fresh baked baguette",
    price: 2,
    unit: "each",
    tags: ["French", "Classic"],
    description: "A classic crispy French baguette with a soft, airy interior."
  },
  {
    name: "Brioche",
    stub: "brioche",
    imgSrc: "images/brioche.jpg",
    imgAlt: "Soft brioche loaf",
    price: 8,
    unit: "per loaf",
    tags: ["Sweet", "Rich"],
    description: "A rich, buttery bread with a soft and tender crumb."
  },
  {
    name: "Cinnamon Raisin Loaf",
    stub: "cinnamon_raisin",
    imgSrc: "images/cinnamon_raisin.jpg",
    imgAlt: "Cinnamon raisin bread",
    price: 12,
    unit: "per loaf",
    tags: ["Sweet", "Breakfast"],
    description: "A sweet loaf packed with cinnamon flavor and juicy raisins."
  },
  {
    name: "Cinnamon Rolls",
    stub: "cinnamon_rolls",
    imgSrc: "images/cinnamon_roll.jpg",
    imgAlt: "Fresh cinnamon rolls",
    price: 12,
    unit: "per dozen",
    tags: ["Pastry", "Sweet"],
    description: "Soft, gooey cinnamon rolls topped with a delicious glaze."
  },
  {
    name: "Croissants",
    stub: "croissants",
    imgSrc: "images/croissants.jpg",
    imgAlt: "Flaky croissants",
    price: 15,
    unit: "per dozen",
    tags: ["French", "Pastry"],
    description: "Flaky, buttery croissants with delicate layers."
  },
  {
    name: "Focaccia",
    stub: "focaccia",
    imgSrc: "images/focaccia.jpg",
    imgAlt: "Focaccia bread",
    price: 6,
    unit: "per sheet",
    tags: ["Italian", "Savory"],
    description: "A soft, olive oil-rich Italian flatbread with a crispy crust."
  },
  {
    name: "French Bread",
    stub: "french_bread",
    imgSrc: "images/french_bread.jpg",
    imgAlt: "French bread loaf",
    price: 4,
    unit: "per loaf",
    tags: ["Classic"],
    description: "A soft inside with a slightly crisp crust, perfect for sandwiches."
  },
  {
    name: "Sourdough",
    stub: "sourdough",
    imgSrc: "images/sourdough.jpg",
    imgAlt: "Sourdough loaf",
    price: 6,
    unit: "per loaf",
    tags: ["Artisan", "Tangy"],
    description: "Naturally fermented sourdough with a tangy flavor and chewy crust."
  },
  {
    name: "Wheat Bread",
    stub: "wheat_bread",
    imgSrc: "images/wheat_bread.jpg",
    imgAlt: "Whole wheat bread",
    price: 6,
    unit: "per loaf",
    tags: ["Healthy", "Whole Grain"],
    description: "A soft, hearty whole wheat loaf made from a proprietary grain blend."
  },
  {
    name: "White Bread",
    stub: "white_bread",
    imgSrc: "images/white_bread.jpg",
    imgAlt: "White bread loaf",
    price: 6,
    unit: "per loaf",
    tags: ["Classic", "Soft"],
    description: "A light and fluffy white bread, perfect for everyday use."
  }
];

products.forEach(product => {
  console.log(product.name + " - $" + product.price);
});

const productList = document.getElementById("product-list");

function renderProducts() {
  productList.innerHTML = "";

  products.forEach(product => {
    const card = document.createElement("div");
    card.classList.add("product-card");

    card.innerHTML = `
      <img src="${product.imgSrc}" alt="${product.imgAlt}">
      <div class="product-info">
        <h3>${product.name}</h3>
        <p>${product.description}</p>
        <div class="price">$${product.price} ${product.unit}</div>
        <button class="add-to-cart" data-id="${product.stub}">
          Add to Cart
        </button>
      </div>
    `;

    productList.appendChild(card);
  });
}

/* display the products on the screen */
renderProducts();

// Array of hero images
const heroImages = [
  "images/main_page_image.jpg",
  "images/wide_wheat.jpg",
  "images/single_wheat_stock.jpg"
];

const heroImg = document.getElementById("hero_image");

if (heroImg) {
  const randomIndex = Math.floor(Math.random() * heroImages.length);
  console.log("Random image:", randomIndex);
  heroImg.src = heroImages[randomIndex];
}

// ===== SEARCH FUNCTIONALITY =====

// Get elements
const searchBtn = document.getElementById("search_btn");
const searchInput = document.getElementById("search");
const resultsContainer = document.getElementById("search-results");

// Only run if search exists on the page
if (searchBtn && searchInput) {

  // Click search
  searchBtn.addEventListener("click", searchProducts);

  // Press Enter to search
  searchInput.addEventListener("keypress", function(e) {
    if (e.key === "Enter") {
      searchProducts();
    }
  });
}

// Search function
function searchProducts() {
  const query = searchInput.value.toLowerCase();

  const filtered = products.filter(product =>
    product.name.toLowerCase().includes(query) ||
    product.description.toLowerCase().includes(query) ||
    product.tags.some(tag => tag.toLowerCase().includes(query))
  );

  displayResults(filtered);

  document.getElementById("product-list").style.display = "none";
}

// Display results
function displayResults(results) {
  if (!resultsContainer) return;

  resultsContainer.innerHTML = "";

  if (results.length === 0) {
    resultsContainer.innerHTML = "<p>No products found.</p>";
    return;
  }

  results.forEach(product => {
    const card = document.createElement("div");
    card.classList.add("product-card");

    card.innerHTML = `
      <img src="${product.imgSrc}" alt="${product.imgAlt}">
      <div class="product-info">
        <h3>${product.name}</h3>
        <p>${product.description}</p>
        <div class="price">$${product.price} ${product.unit}</div>
        <button class="add-to-cart" data-id="${product.stub}">
          Add to Cart
        </button>
      </div>
    `;

    resultsContainer.appendChild(card);
  });
}