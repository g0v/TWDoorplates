# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("#city-code-selector").on "click", "button", ->
	$this = $(this)
	buildAreaButtons($this.val())
	$("#doorplate-search-form input[name=cityCode]").val($this.val())
	$("#city-code-selector button").removeClass("active")
	$this.addClass("active")

$("#area-code-selector").on "click", "button", ->
	$this = $(this)
	$("#doorplate-search-form input[name=areaCode]").val($this.val())
	$("#area-code-selector button.active").removeClass("active")
	$this.addClass("active")

buildAreaButtons = (cityCode) ->
	$("#area-code-selector").empty()
	$("#area-code-selector").append("<button type=\"button\" class=\"btn btn-default active\" value=\"\">不拘</button>")
	areaCode = $.map($(document).attr("cityAreaCodes"), (val) ->
	    val.areas if val.cityCode == cityCode
	)
	$(areaCode).each ->
		node = $("<button type=\"button\" class=\"btn btn-default\"></button>")
		node.val($(this)[0].areaCode)
		node.text($(this)[0].areaName)
		$("#area-code-selector").append(node)

buildDoorplates = (doorplates)->
	$("#doorplate-list").empty()
	if $(doorplates).length > 0
		$("#doorplate-list").append($("<table class='table table-striped'><tbody></tbody></table>"))
		$(doorplates).each ->
			content = $(this)[0].address
			content = emphasizeVillage(content)
			content = emphasizeNeighbor(content)
			node = $("<tr><td>#{content}</td></tr>")
			$("#doorplate-list tbody").append(node)
	else
		$("#doorplate-list").append $("<div class='jumbotron'><h3>沒有資料</h3></div>")

emphasizeVillage = (str)->
	emphasize(str, "strong alley", str.substr(str.match(/[區鄉鎮市][^區鄉鎮市]{1,3}里/).index+1).match(/\D{1,3}里/)[0])

emphasizeNeighbor = (str)->
	emphasize(str, "strong neighbor", /\d{3}鄰/)

emphasize = (str, classes, regexp)->
	str.replace(regexp, "<span class='#{classes}'>"+str.match(regexp)[0]+"</span>")

$.ajax {
	url: "/assets/cityAreaCodes.json",
	type: "GET",
	dataType: "json"
	success: (data)->
		$(document).attr("cityAreaCodes", data)
		buildAreaButtons(data[0].cityCode)
		$("#city-code-selector button")[0].click()
	,
	error: ->
		alert("Error loading area codes")
}

$(document).ready ->
	$("#doorplate-search-form").on("ajax:success", (e, data, status, xhr) ->
		buildDoorplates xhr.responseJSON.rows
	).on "ajax:error", (e, xhr, status, error) ->
		$("#doorplate-list").append $("<div class='jumbotron'><h3>查詢失敗</h3></div>")