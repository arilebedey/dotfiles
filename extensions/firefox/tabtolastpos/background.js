// background.js
browser.commands.onCommand.addListener((command) => {
  if (command === "move-tab-to-first") {
    moveTabToLast();
  }
});

function moveTabToLast() {
  // Get the current tab
  browser.tabs.query({ currentWindow: true, active: true })
    .then((tabs) => {
      if (tabs.length > 0) {
        const currentTab = tabs[0];
        
        // First get all tabs to know the count
        browser.tabs.query({ currentWindow: true })
          .then((allTabs) => {
            // Move the tab to the last position
            browser.tabs.move(currentTab.id, { index: -1 })
              .catch((error) => {
                console.error(`Error moving tab: ${error}`);
              });
          })
          .catch((error) => {
            console.error(`Error querying all tabs: ${error}`);
          });
      }
    })
    .catch((error) => {
      console.error(`Error querying tabs: ${error}`);
    });
}
