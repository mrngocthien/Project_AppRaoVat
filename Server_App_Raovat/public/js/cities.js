//City list manager
$(document).ready(function() {
    var url = "http://localhost:3000";
    
    //Load city list
    $.post(url + "/city", function(data2) {
        if (data2.result == 1) {
            $("#city_List").html("");
            data2.list.forEach(function(city) {
                $("#city_List").append('<li class="city" id="' + city._id + '">' + city.name + '</li>');  
            });
        }
    });

    //Add new city
    $("#butt_AddNewCity").click(function() {
        $.post(url + "/city/add", {name: $("#cityName").val()}, function(data) {
            console.log(data);
            if (data.result == 1) {
                $("#cityName").val("");
                $.post(url + "/city", function(data2) {
                    if (data2.result == 1) {
                        $("#city_List").html("");
                        data2.list.forEach(function(city) {
                            $("#city_List").append('<li class="city" id="' + city._id + '">' + city.name + '</li>');  
                        });
                    }
                })
            }
        });

    });

    //Update city list
    $(document).on("click", ".city",function() {
        var city_clicked = $(this).html();
        var Id_City = $(this).attr("id");
        $("#cityName_Update").val(city_clicked);
        $("#cityID_hidden").val(Id_City);
    });

    //Function for Update button
    $("#butt_UpdateCity").click(function(){
        $.post(url + "/city/update", {
            CityID: $("#cityID_hidden").val(),
            name: $("#cityName_Update").val()
        }, function(data) {
            //Reload updated city list
            if (data.result == 1) {
                $("#cityName_Update").val("");
                $.post(url + "/city", function(data2) {
                    if (data2.result == 1) {
                        $("#city_List").html("");
                        data2.list.forEach(function(city) {
                            $("#city_List").append('<li class="city" id="' + city._id + '">' + city.name + '</li>');  
                        });
                    }
                }); 
            }
        });
    });

    //Function for Delete button
    $("#butt_DeleteCity").click(function(){
        var user_Selected = confirm("Are you sure you want to delete this city ?");
        if (user_Selected) {
            $.post(url + "/city/delete", {
                CityID: $("#cityID_hidden").val(),
            }, function(data) {
                //Reload updated city list
                if (data.result == 1) {
                    $("#cityName_Update").val("");
                    $.post(url + "/city", function(data2) {
                        if (data2.result == 1) {
                            $("#city_List").html("");
                            data2.list.forEach(function(city) {
                                $("#city_List").append('<li class="city" id="' + city._id + '">' + city.name + '</li>');  
                            });
                        }
                    }); 
                }
            });
        }
        
    });
});