function showTab(tabId) {
    var tabs = document.querySelectorAll('.tabs .tab');
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].classList.remove('active');
    }

    var tabIndex = parseInt(tabId.replace('tab', '')) - 1;
    if (tabs[tabIndex]) {
        tabs[tabIndex].classList.add('active');
    }

    var contents = document.querySelectorAll('.content');
    for (var i = 0; i < contents.length; i++) {
        contents[i].style.display = 'none';
    }

    var selectedTab = document.getElementById(tabId);
    if (selectedTab) {
        selectedTab.style.display = 'block';
    }

    if (tabId === 'tab1') {
        loadTabContent(selectedTab, 'jsp/tab1.jsp');
    }

    if(tabId === 'tab2') {
        loadTabContent(selectedTab, 'jsp/tab2.jsp');
    }

    if(tabId === 'tab3') {
        loadTabContent(selectedTab, 'jsp/tab3.jsp');
    }

    if(tabId === 'tab4') {
        loadTabContent(selectedTab, 'jsp/tab4.jsp');
    }

    if(tabId === 'tab5') {
        loadTabContent(selectedTab, 'jsp/tab5.jsp');
    }

    if(tabId === 'tab6') {
        loadTabContent(selectedTab, 'jsp/tab6.jsp');
    }

    if(tabId === 'tab7') {
        loadTabContent(selectedTab, 'jsp/tab7.jsp');
    }

    if(tabId === 'tab8') {
        loadTabContent(selectedTab, 'jsp/tab8.jsp');
    }

}

function loadTabContent(container, url) {
    if (container.classList.contains('content-loaded')) {
        return;
    }

    fetch(url)
        .then(function (response) {
            return response.text();
        })
        .then(function (html) {
            container.innerHTML = html;
            container.classList.add('content-loaded');

            var scripts = container.getElementsByTagName("script");
            for (var i = 0; i < scripts.length; i++) {
                var newScript = document.createElement("script");
                newScript.text = scripts[i].text;
                document.body.appendChild(newScript);
            }
        })
        .catch(function (err) {
            console.error("Error loading tab:", err);
            container.innerHTML = "<p style='color:red; padding:20px;'>Error loading content.</p>";
        });
}

document.addEventListener("DOMContentLoaded", function() {
   showTab('tab1');
});