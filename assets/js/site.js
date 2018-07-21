function setupNavigationBarHighlighting() {
  const selectedNavItem = document.querySelector(`nav li.${pageClass.toLowerCase()}-page-nav-link`);
  if (selectedNavItem) {
    selectedNavItem.classList.add('active');
  }
}

function resizeYoutubeVideo(video) {
  const width = video.clientWidth;
  const newHeight = width*9/16;
  video.height = newHeight;
}

function resizeYoutubeVideos() {
  const videos = document.querySelectorAll(".youtube-video");
  videos.forEach(resizeYoutubeVideo);
}

function setupSidenav() {
  const elems = document.querySelectorAll('.sidenav');
  M.Sidenav.init(elems);
}

window.addEventListener('resize', function(event) {
  resizeYoutubeVideos();
});

document.addEventListener("DOMContentLoaded", function(event) {
  setupNavigationBarHighlighting();
  resizeYoutubeVideos();
  setupSidenav();
});