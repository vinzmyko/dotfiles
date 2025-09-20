(function() {
    'use strict';

    // Only run if we are on a YouTube watch page
    if (!window.location.pathname.startsWith('/watch')) {
        return;
    }

    function skipAds() {
        try {
            // Skip button clicking
            const skipButtons = document.querySelectorAll('.videoAdUiSkipButton, .ytp-ad-skip-button-modern, .ytp-skip-ad-button');
            skipButtons.forEach(btn => {
                if (btn && typeof btn.click === 'function') {
                    btn.click();
                }
            });

            // Speed through ads
            const adShowing = document.querySelector('.ad-showing');
            if (adShowing) {
                const video = document.querySelector('video');
                if (video && video.duration) {
                    video.currentTime = video.duration;
                }
            }
        } catch (error) {
            console.log('Ad skipper error:', error.message);
        }
    }

    // Use a MutationObserver to efficiently detect when ads appear
    const observer = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
            if (mutation.addedNodes.length > 0) {
                skipAds();
            }
        }
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
})();
