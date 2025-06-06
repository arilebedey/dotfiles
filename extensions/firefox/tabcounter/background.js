let tabCount = 0;

// Function to update the tab count
function updateTabCount() {
  browser.tabs.query({}).then((tabs) => {
    tabCount = tabs.length;

    // Update the badge with the tab count
    browser.browserAction.setBadgeText({ text: tabCount.toString() });
    browser.browserAction.setBadgeBackgroundColor({ color: "#4a90e2" });

    // Also update the popup if it's open
    browser.runtime.sendMessage({ action: "updateCount", count: tabCount });
  });
}

// Listen for tab events to keep the count updated
browser.tabs.onCreated.addListener(updateTabCount);
browser.tabs.onRemoved.addListener(updateTabCount);

// Initial count when browser starts
updateTabCount();
