function updatePopupCount() {
  browser.runtime
    .sendMessage({ action: "getCount" })
    .then((response) => {
      document.getElementById("tabCount").textContent = response.count;
    })
    .catch((error) => {
      console.error("Error getting tab count:", error);
    });
}

// Listen for messages from the background script
browser.runtime.onMessage.addListener((message) => {
  if (message.action === "updateCount") {
    document.getElementById("tabCount").textContent = message.count;
  }
  return true;
});

// Initialize when popup opens
document.addEventListener("DOMContentLoaded", updatePopupCount);
