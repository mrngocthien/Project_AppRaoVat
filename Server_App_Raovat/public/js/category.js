$(document).ready(function() {
    var url = "http://localhost:3000";
    
    //load Category list
    $.post(url + "/category", function(data) {
        $("#list_Cate").html("");
        if (data.result == 1) {
            data.CateList.forEach(function(cate) {
                $("#list_Cate").append('<li class="cate" src="'+cate.image+'" id="'+cate._id+'">'+cate.name+'</li>');   
            });    
        }
    });

    //Add product image
    $("#product_Image").change(function(){
       
        var data = new FormData();
        jQuery.each(jQuery('#product_Image')[0].files, function(i, file) {
            console.log('hinhdaidien');
            data.append('hinhdaidien', file);
        });

        jQuery.ajax({
            url: url + '/uploadFile',
            data: data,
            cache: false,
            contentType: false,
            processData: false,
            method: 'POST',
            type: 'POST', // For jQuery < 1.9
            success: function(data){
                if(data.result==1){
                    console.log(data);
                    // $("#imgAvatar").attr("src","upload/" + data.file);
                    $("#ImgCateNew").attr("src", url + '/upload/' + data.urlFile.filename);
                    $("#file_ImageCate").val(data.urlFile.filename);
                }else{
                    alert("Upload fail!");
                }
            }
        });
    });

    //Add new category data
    $("#butt_AddNewCate").click(function(){
        if ($("#cate_Name").val().length == 0 ||
            $("#file_ImageCate").val().length == 0
        ) {
            alert("Missing parameters !");
        } else {
            $.post(url + "/category/AddNew", {
                name: $("#cate_Name").val(),
                image: $("#file_ImageCate").val()
                }, function(data) {
                    if (data.result == 1) {
                        $("#cate_Name").val("");
                        $("#ImgCateNew").attr("src", "");
                        $("#product_Image").val("");
                        $.post(url + "/category", function(data) {
                            $("#list_Cate").html("");
                            if (data.result == 1) {
                                data.CateList.forEach(function(cate) {
                                    $("#list_Cate").append('<li class="cate" src="'+cate.image+'" id="'+cate._id+'">'+ cate.name+'</li>');
                                });   
                            }
                        });
                    } else {
                        console.log("Bad");
                    }
            });
        }
        
    });

    //Detail category
    $(document).on("click", ".cate", function(){
        var productSrc = $(this).attr("src");
        var nameCate = $(this).html();
        var idCate = $(this).attr("id");

        $("#cate_Detail").attr("src",url + "/upload/" + productSrc);
        $("#cateName_Detail").val(nameCate);
        $("#file_ImageCate_Detail").val(productSrc);
        $("#idCate_Detail").val(idCate);
    });

    $("#product_image_Detail").change(function(){
        var data = new FormData();
        jQuery.each(jQuery('#product_image_Detail')[0].files, function(i, file) {
            console.log('hinhdaidien');
            data.append('hinhdaidien', file);
        });

        jQuery.ajax({
            url: url + '/uploadFile',
            data: data,
            cache: false,
            contentType: false,
            processData: false,
            method: 'POST',
            type: 'POST', // For jQuery < 1.9
            success: function(data){
                if(data.result==1){
                    console.log(data);
                    // $("#imgAvatar").attr("src","upload/" + data.file);
                    $("#cate_Detail").attr("src", url + '/upload/' + data.urlFile.filename);
                    $("#file_ImageCate_Detail").val(data.urlFile.filename);
                }else{
                    alert("Upload fail!");
                }
            }
        });
    });

    //Update category
    $("#butt_Update_Cate").click(function() {
        $.post(url + "/category/update", {
            id: $("#idCate_Detail").val(),
            CateName: $("#cateName_Detail").val(),
            ImageCate: $("#file_ImageCate_Detail").val()
        }, function(data){
            if (data.result == 1) {
                $.post(url + "/category", function(data) {
                    $("#list_Cate").html("");
                    if (data.result == 1) {
                        $("#cateName_Detail").val("");
                        $("#cate_Detail").attr("src", "");
                        $("#product_image_Detail").val("");
                        data.CateList.forEach(function(cate) {
                            $("#list_Cate").append('<li class="cate" src="'+cate.image+'" id="'+cate._id+'">'+cate.name+'</li>');
                        });    
                    }
                });
            } else {
                alert("Update cate failed !");
            }
        });
    });
    
    //Delete category
    $("#butt_Delete_Cate").click(function() {
        var user_Selected = confirm("Are you sure you want to delete this category ?");
        if (user_Selected) {
            $.post(url + "/category/delete", {id: $("#idCate_Detail").val()}, function(data) {
                if (data.result == 1) {
                    $.post(url + "/category", function(data) {
                        $("#list_Cate").html("");
                        if (data.result == 1) {
                            $("#cateName_Detail").val("");
                            $("#cate_Detail").attr("src", "");
                            $("#product_image_Detail").val("");
                            data.CateList.forEach(function(cate) {
                                $("#list_Cate").append('<li class="cate" src="'+cate.image+'" id="'+cate._id+'">'+cate.name+'</li>');
                            });    
                        }
                    });
                } else {
                    alert("Delete cate failed !");
                }
            });
        }
        
    });
});