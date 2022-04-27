$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "flex" : "none";
        }
    });

    document.onkeyup = function(data) {
        if (data.which == 27) { // Escape key
            $.post('https://adame-core/escape', JSON.stringify({}));
        }
    };

    $("#register").submit(function(event) {
        event.preventDefault(); // Prevent form from submitting

        // Verify date
        var date = $("#dateofbirth").val();
        var dateCheck = new Date($("#dateofbirth").val());

        if (dateCheck == "Invalid Date") {
            date == "invalid";
        }

        $.post('https://adame-core/register', JSON.stringify({
            firstname: $("#firstname").val(),
            lastname: $("#lastname").val(),
            dateofbirth: date,
            height: $("#height").val(),
            sex: $(".sex:checked").val()
        }));
    });
});