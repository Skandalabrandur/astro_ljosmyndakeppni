var registerImages = function() {
    $(".fullstort").on('click', function(event) {
        event.stopPropagation();
        event.stopImmediatePropagation();

        if ($(event.target).hasClass('fullur')) {
            document.exitFullscreen()
        } else {
            event.target.requestFullscreen()
        }
        $(event.target).toggleClass('fullur')
    });
}
