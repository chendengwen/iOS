/*人体图JS Author:lven 20170113*/

//标签内联方法,选项卡切换
function openTab(evt, IDName) {
	var i,
	tabcontent,
	tablinks,
	target;
	tabcontent = document.getElementsByClassName("tabcontent");
	for (i = 0; i < tabcontent.length; i++) {
		tabcontent[i].style.display = "none";
	}
	tablinks = document.getElementsByClassName("tablinks");
	for (i = 0; i < tabcontent.length; i++) {
		tablinks[i].className = tablinks[i].className.replace(" active", "");
	}
	target = evt.currentTarget || evt.target;
	target.className += " active";
	

	//点击人体图.跳转到器官页面
	if(IDName=="body_pic"&&index.history!=""){
		document.getElementById("pic").style.display = "block";
		var link="#"+index.history;
		$(link).show();
	}else{
		document.getElementById(IDName).style.display = "block";
	}
	

	//滚动条初始化
	if (!scroll_right) {
		scroll_right = new IScroll('#right_wrapper', {
          preventDefault: false,
				probeType: 3,
				scrollX: false,
				scrollY: true,
				click: true,
				vScrollbar: false
			})
	}
	

	//左侧滚动条初始化
	if (!scroll_left) {
		scroll_left = new IScroll('#left_wrapper', {
          preventDefault: false,
				probeType: 3,
				scrollX: false,
				scrollY: true,
				click: true,
				vScrollbar: false
			})
	}

}

var scroll_right; //右侧滚动条
var scroll_left; //右侧滚动条
var index = {
	init: function () {
		this.bindTurnSex();
		this.bindTurnBack();
		this.bindOne2Two();
		this.drawManFront();
		this.bindOrganEvent();
		this.writeSymptomList();
		this.bindEvent();
		// $("#man_front_head").click();

	},

	//给所有的a标签绑定事件
	bindEvent: function () {
		$("#right_wrapper ul li a").click(function () {
			var a = $(this);
			var id = a.attr("id");
			if (!!id) {
				// HealthBAT.chooseSymptom(id);
			}
		});
		//返回事件
		$(".returnBtn").click(function(){
			$("#body_pic").show();
			$("#pic").hide();
			index.history='';
		})
	},
	history:"",
	option: {

		symp1to2: {
			symp_body: "全身症状",
			symp_skin: "皮肤症状",
			symp_head_face: "头面部",
			symp_swallow_neck: "咽颈部",
			symp_chest: "胸部",
			symp_waist_belly: "腰腹部",
			symp_hand: "上肢",
			symp_foot: "下肢",
			symp_excrete: "排泄部",
			symp_man_sex: "男性生殖",
			symp_girl_sex: "女性盆骨",

		},
		idTolink: {
			man_front_head: "symp_head",
			man_front_eye: "symp_eye",
			man_front_nose: "symp_nose",
			man_front_ear: "symp_ear",
			man_front_mouth: "symp_mouth",
			man_front_throat: "symp_throat",
			man_front_spine: "symp_spine",
			man_front_respiratory: "symp_respiratory",
			man_front_lung: "symp_lung",
			man_front_chest: "symp_chest",
			man_front_heart: "symp_heart",
			man_front_liver: "symp_liver",
			man_front_stomach: "symp_stomach",
			man_front_kidney: "symp_kidney",
			man_front_waist: "symp_waist",
			man_front_intestines: "symp_intestines",
			man_front_foot: "symp_foot",
			man_front_left_hand: "symp_hand",
			man_front_right_hand: "symp_hand",
			man_front_genitals: "symp_man_sex",
			man_front_bladder: "symp_bladder",
			man_back_head: "symp_head",
			man_back_neck: "symp_spine",
			man_back_left_hand: "symp_hand",
			man_back_right_hand: "symp_hand",
			man_back_back: "symp_back",
			man_back_waist: "symp_waist",
			man_back_hip: "symp_excrete",
			man_back_foot: "symp_foot",
			girl_front_head: "symp_head",
			girl_front_eye: "symp_eye",
			girl_front_nose: "symp_nose",
			girl_front_ear: "symp_ear",
			girl_front_mouth: "symp_mouth",
			girl_front_throat: "symp_throat",
			girl_front_spine: "symp_spine",
			girl_front_respiratory: "symp_respiratory",
			girl_front_lung: "symp_lung",
			girl_front_chest: "symp_chest",
			girl_front_heart: "symp_heart",
			girl_front_liver: "symp_liver",
			girl_front_stomach: "symp_stomach",
			girl_front_kidney: "symp_kidney",
			girl_front_waist: "symp_waist",
			girl_front_intestines: "symp_intestines",
			girl_front_foot: "symp_foot",
			girl_front_left_hand: "symp_hand",
			girl_front_right_hand: "symp_hand",
			girl_front_genitals: "symp_girl_sex",
			girl_front_bladder: "symp_bladder",
			girl_back_head: "symp_head",
			girl_back_neck: "symp_spine",
			girl_back_left_hand: "symp_hand",
			girl_back_right_hand: "symp_hand",
			girl_back_back: "symp_back",
			girl_back_waist: "symp_waist",
			girl_back_hip: "symp_excrete",
			girl_back_foot: "symp_foot"
		},
		idToOrgan: {
			man_front_head: "organ_man_front_head",
			man_front_neck: "organ_man_front_head",
			man_front_chest: "organ_man_front_body",
			man_front_belly: "organ_man_front_body",
			man_front_sex: "organ_man_front_sex",
			girl_front_head: "organ_girl_front_head",
			girl_front_neck: "organ_girl_front_head",
			girl_front_chest: "organ_girl_front_body",
			girl_front_belly: "organ_girl_front_body",
			girl_front_sex: "organ_girl_front_sex",
		},
		symp1to2ByCName: {
			"全身症状": "symp_body",
			"皮肤症状": "symp_skin",
			"口腔": "symp_mouth",
			"眼睛": "symp_eye",
			"鼻子": "symp_nose",
			"耳朵": "symp_ear",
			"头部": "symp_head",
			"咽喉": "symp_throat",
			"颈椎": "symp_spine",
			"肺": "symp_lung",
			"心脏": "symp_heart",
			"呼吸道": "symp_respiratory",
			"肝": "symp_liver",
			"胃": "symp_stomach",
			"肠": "symp_intestines",
			"肾": "symp_kidney",
			"胸部": "symp_chest",
			"背部": "symp_back",
			"皮肤症状": "symp_skin",
			"皮肤症状": "symp_skin",
			"胸部": "symp_chest",
			"腰腹部": "symp_waist",
			"上肢": "symp_hand",
			"下肢": "symp_foot",
			"排泄部": "symp_excrete",
			"男性生殖": "symp_man_sex",
			"女性生殖": "symp_girl_sex",
			"膀胱": "symp_bladder",
		},
		man_front: {
			head: [{
					x: '327 ',
					y: '30 '
				}, {
					x: '460 ',
					y: '32 '
				}, {
					x: '422 ',
					y: '197 '
				}, {
					x: '349 ',
					y: '197 '
				}, {
					x: '324 ',
					y: '107 '
				}, {
					x: '327 ',
					y: '30 '
				}
			],
			neck: [{
					x: '349 ',
					y: '197 '
				}, {
					x: '422 ',
					y: '195 '
				}, {
					x: '478 ',
					y: '228 '
				}, {
					x: '382 ',
					y: '245 '
				}, {
					x: '295 ',
					y: '226 '
				}, {
					x: '349 ',
					y: '197 '
				}
			],
			chest: [{
					x: '273 ',
					y: '232 '
				}, {
					x: '293 ',
					y: '226 '
				}, {
					x: '382 ',
					y: '245 '
				}, {
					x: '478 ',
					y: '228 '
				}, {
					x: '498 ',
					y: '237 '
				}, {
					x: '470 ',
					y: '372 '
				}, {
					x: '297 ',
					y: '373 '
				}, {
					x: '273 ',
					y: '232 '
				}
			],
			left_hand: [{
					x: '270 ',
					y: '231 '
				}, {
					x: '248 ',
					y: '266 '
				}, {
					x: '240 ',
					y: '396 '
				}, {
					x: '202 ',
					y: '537 '
				}, {
					x: '154 ',
					y: '612 '
				}, {
					x: '200 ',
					y: '656 '
				}, {
					x: '243 ',
					y: '636 '
				}, {
					x: '294 ',
					y: '371 '
				}, {
					x: '270 ',
					y: '231 '
				}
			],
			right_hand: [{
					x: '500 ',
					y: '237 '
				}, {
					x: '518 ',
					y: '266 '
				}, {
					x: '530 ',
					y: '406 '
				}, {
					x: '603 ',
					y: '604 '
				}, {
					x: '575 ',
					y: '652 '
				}, {
					x: '522 ',
					y: '635 '
				}, {
					x: '470 ',
					y: '372 '
				}, {
					x: '500 ',
					y: '237 '
				}
			],
			belly: [{
					x: '295 ',
					y: '384 '
				}, {
					x: '468 ',
					y: '384 '
				}, {
					x: '461 ',
					y: '473 '
				}, {
					x: '473 ',
					y: '506 '
				}, {
					x: '380 ',
					y: '520 '
				}, {
					x: '297 ',
					y: '506 '
				}, {
					x: '306 ',
					y: '472 '
				}, {
					x: '295 ',
					y: '384 '
				}
			],
			sex: [{
					x: '294 ',
					y: '505 '
				}, {
					x: '379 ',
					y: '519 '
				}, {
					x: '473 ',
					y: '505 '
				}, {
					x: '487 ',
					y: '611 '
				}, {
					x: '382 ',
					y: '624 '
				}, {
					x: '284 ',
					y: '609 '
				}, {
					x: '294 ',
					y: '505 '
				}
			],
			foot: [{
					x: '284 ',
					y: '609 '
				}, {
					x: '382 ',
					y: '624 '
				}, {
					x: '487 ',
					y: '611 '
				}, {
					x: '464 ',
					y: '798 '
				}, {
					x: '457 ',
					y: '1056 '
				}, {
					x: '310 ',
					y: '1056 '
				}, {
					x: '298 ',
					y: '807 '
				}, {
					x: '284 ',
					y: '609 '
				}
			]
		},
		man_back: {
			head: [{
					x: '317 ',
					y: '56 '
				}, {
					x: '443 ',
					y: '55 '
				}, {
					x: '443 ',
					y: '209 '
				}, {
					x: '317 ',
					y: '210 '
				}, {
					x: '317 ',
					y: '56 '
				}
			],
			neck: [{
					x: '348 ',
					y: '210 '
				}, {
					x: '418 ',
					y: '210 '
				}, {
					x: '427 ',
					y: '239 '
				}, {
					x: '472 ',
					y: '254 '
				}, {
					x: '384 ',
					y: '267 '
				}, {
					x: '303 ',
					y: '254 '
				}, {
					x: '340 ',
					y: '239 '
				}, {
					x: '348 ',
					y: '210 '
				}
			],
			back: [{
					x: '275 ',
					y: '256 '
				}, {
					x: '300 ',
					y: '254 '
				}, {
					x: '380 ',
					y: '271 '
				}, {
					x: '473 ',
					y: '257 '
				}, {
					x: '499 ',
					y: '264 '
				}, {
					x: '476 ',
					y: '349 '
				}, {
					x: '469 ',
					y: '403 '
				}, {
					x: '296 ',
					y: '403 '
				}, {
					x: '296 ',
					y: '352 '
				}, {
					x: '275 ',
					y: '256 '
				}
			],
			foot: [{
					x: '279 ',
					y: '652 '
				}, {
					x: '484 ',
					y: '649 '
				}, {
					x: '458 ',
					y: '1076 '
				}, {
					x: '317 ',
					y: '1076 '
				}, {
					x: '279 ',
					y: '652 '
				}
			],
			left_hand: [{
					x: '269 ',
					y: '262 '
				}, {
					x: '251 ',
					y: '279 '
				}, {
					x: '243 ',
					y: '385 '
				}, {
					x: '202 ',
					y: '568 '
				}, {
					x: '163 ',
					y: '641 '
				}, {
					x: '195 ',
					y: '685 '
				}, {
					x: '239 ',
					y: '670 '
				}, {
					x: '243 ',
					y: '586 '
				}, {
					x: '281 ',
					y: '498 '
				}, {
					x: '296 ',
					y: '416 '
				}, {
					x: '269 ',
					y: '262 '
				}
			],
			right_hand: [{
					x: '502 ',
					y: '264 '
				}, {
					x: '522 ',
					y: '284 '
				}, {
					x: '522 ',
					y: '376 '
				}, {
					x: '572 ',
					y: '560 '
				}, {
					x: '606 ',
					y: '637 '
				}, {
					x: '561 ',
					y: '676 '
				}, {
					x: '522 ',
					y: '658 '
				}, {
					x: '525 ',
					y: '590 '
				}, {
					x: '472 ',
					y: '415 '
				}, {
					x: '502 ',
					y: '264 '
				}
			],
			hip: [{
					x: '294 ',
					y: '531 '
				}, {
					x: '378 ',
					y: '543 '
				}, {
					x: '469 ',
					y: '531 '
				}, {
					x: '485 ',
					y: '644 '
				}, {
					x: '383 ',
					y: '643 '
				}, {
					x: '325 ',
					y: '650 '
				}, {
					x: '278 ',
					y: '648 '
				}, {
					x: '283 ',
					y: '582 '
				}, {
					x: '294 ',
					y: '531 '
				}
			],
			waist: [{
					x: '296 ',
					y: '404 '
				}, {
					x: '466 ',
					y: '406 '
				}, {
					x: '472 ',
					y: '521 '
				}, {
					x: '376 ',
					y: '533 '
				}, {
					x: '296 ',
					y: '523 '
				}, {
					x: '302 ',
					y: '490 '
				}, {
					x: '296 ',
					y: '404 '
				}
			]
		},
		girl_front: {
					head: [{
					x: '350 ',
					y: '23 '
				}, {
					x: '417 ',
					y: '23 '
				}, {
					x: '421 ',
					y: '57 '
				}, {
					x: '452 ',
					y: '91 '
				}, {
					x: '453 ',
					y: '155 '
				}, {
					x: '408 ',
					y: '199 '
				}, {
					x: '364 ',
					y: '199 '
				}, {
					x: '314 ',
					y: '150 '
				}, {
					x: '318 ',
					y: '96 '
				}, {
					x: '343 ',
					y: '59 '
				}, {
					x: '350 ',
					y: '23 '
				}
			],
			neck: [{
					x: '363 ',
					y: '197 '
				}, {
					x: '405 ',
					y: '197 '
				}, {
					x: '427 ',
					y: '233 '
				}, {
					x: '382 ',
					y: '246 '
				}, {
					x: '340 ',
					y: '234 '
				}, {
					x: '363 ',
					y: '197 '
				}
			],
			chest: [{
					x: '333 ',
					y: '241 '
				}, {
					x: '378 ',
					y: '249 '
				}, {
					x: '429 ',
					y: '236 '
				}, {
					x: '468 ',
					y: '252 '
				}, {
					x: '449 ',
					y: '304 '
				}, {
					x: '440 ',
					y: '373 '
				}, {
					x: '438 ',
					y: '388 '
				}, {
					x: '327 ',
					y: '385 '
				}, {
					x: '314 ',
					y: '334 '
				}, {
					x: '322 ',
					y: '296 '
				}, {
					x: '314 ',
					y: '248 '
				}, {
					x: '333 ',
					y: '241 '
				}
			],
			left_hand: [{
					x: '309 ',
					y: '252 '
				}, {
					x: '294 ',
					y: '261 '
				}, {
					x: '238 ',
					y: '525 '
				}, {
					x: '201 ',
					y: '576 '
				}, {
					x: '218 ',
					y: '608 '
				}, {
					x: '254',
					y: '599 '
				}, {
					x: '262',
					y: '543 '
				}, {
					x: '305',
					y: '391 '
				}, {
					x: '314',
					y: '293 '
				}, {
					x: '309',
					y: '252 '
				}
			],
			right_hand: [{
					x: '451 ',
					y: '306 '
				}, {
					x: '470 ',
					y: '253 '
				}, {
					x: '515 ',
					y: '419 '
				}, {
					x: '521 ',
					y: '518 '
				}, {
					x: '554 ',
					y: '572 '
				}, {
					x: '525 ',
					y: '608 '
				}, {
					x: '487 ',
					y: '593 '
				}, {
					x: '492 ',
					y: '537 '
				}, {
					x: '451 ',
					y: '306 '
				}
			],
			belly: [{
					x: '330 ',
					y: '392 '
				}, {
					x: '439 ',
					y: '392 '
				}, {
					x: '468 ',
					y: '505 '
				}, {
					x: '382 ',
					y: '520 '
				}, {
					x: '292 ',
					y: '505 '
				}, {
					x: '321 ',
					y: '423 '
				}, {
					x: '325 ',
					y: '415*'
				}, {
					x: '330 ',
					y: '392 '
				}
			],
			sex: [{
					x: '291 ',
					y: '506 '
				}, {
					x: '379 ',
					y: '521 '
				}, {
					x: '468 ',
					y: '506 '
				}, {
					x: '475 ',
					y: '534 '
				}, {
					x: '380 ',
					y: '569 '
				}, {
					x: '288 ',
					y: '532 '
				}, {
					x: '291 ',
					y: '506 '
				}
			],
			foot: [{
					x: '286 ',
					y: '535 '
				}, {
					x: '307 ',
					y: '1045 '
				}, {
					x: '454 ',
					y: '1045 '
				}, {
					x: '475 ',
					y: '535 '
				}, {
					x: '380 ',
					y: '570 '
				}, {
					x: '286 ',
					y: '535 '
				}
			]
		},
		girl_back: {
			head: [{
					x: '319 ',
					y: '19 '
				}, {
					x: '452 ',
					y: '22 '
				}, {
					x: '453 ',
					y: '129 '
				}, {
					x: '407 ',
					y: '160 '
				}, {
					x: '353 ',
					y: '160 '
				}, {
					x: '317 ',
					y: '122 '
				}, {
					x: '319 ',
					y: '19 '
				}
			],
			back: [{
					x: '339 ',
					y: '202 '
				}, {
					x: '384 ',
					y: '206 '
				}, {
					x: '430 ',
					y: '202 '
				}, {
					x: '466 ',
					y: '221 '
				}, {
					x: '447 ',
					y: '266 '
				}, {
					x: '454 ',
					y: '293 '
				}, {
					x: '442 ',
					y: '333 '
				}, {
					x: '382 ',
					y: '333 '
				}, {
					x: '326 ',
					y: '333 '
				}, {
					x: '314 ',
					y: '296 '
				}, {
					x: '324 ',
					y: '269 '
				}, {
					x: '314 ',
					y: '216 '
				}, {
					x: '339 ',
					y: '202 '
				}
			],
			neck: [{
					x: '364 ',
					y: '161 '
				}, {
					x: '407 ',
					y: '161 '
				}, {
					x: '426 ',
					y: '197 '
				}, {
					x: '385 ',
					y: '205 '
				}, {
					x: '344 ',
					y: '197 '
				}, {
					x: '364 ',
					y: '161 '
				}
			],
			foot: [{
					x: '282 ',
					y: '550 '
				}, {
					x: '310 ',
					y: '1009 '
				}, {
					x: '453 ',
					y: '1009 '
				}, {
					x: '482 ',
					y: '549 '
				}, {
					x: '433 ',
					y: '568 '
				}, {
					x: '388 ',
					y: '560 '
				}, {
					x: '392 ',
					y: '992 '
				}, {
					x: '365 ',
					y: '980 '
				}, {
					x: '372 ',
					y: '559 '
				}, {
					x: '326 ',
					y: '567 '
				}, {
					x: '282 ',
					y: '550 '
				}
			],
			left_hand: [{
					x: '310 ',
					y: '216 '
				}, {
					x: '289 ',
					y: '237 '
				}, {
					x: '238 ',
					y: '476 '
				}, {
					x: '209 ',
					y: '528 '
				}, {
					x: '212 ',
					y: '566 '
				}, {
					x: '259 ',
					y: '566 '
				}, {
					x: '311 ',
					y: '297 '
				}, {
					x: '310 ',
					y: '216 '
				}
			],
			right_hand: [{
					x: '468 ',
					y: '222 '
				}, {
					x: '450 ',
					y: '265 '
				}, {
					x: '456 ',
					y: '287 '
				}, {
					x: '491 ',
					y: '501 '
				}, {
					x: '493 ',
					y: '574 '
				}, {
					x: '556 ',
					y: '565 '
				}, {
					x: '538 ',
					y: '497 '
				}, {
					x: '504 ',
					y: '316 '
				}, {
					x: '468 ',
					y: '222 '
				}
			],
			hip: [{
					x: '293 ',
					y: '464 '
				}, {
					x: '378 ',
					y: '476 '
				}, {
					x: '468 ',
					y: '467 '
				}, {
					x: '481 ',
					y: '539 '
				}, {
					x: '446 ',
					y: '561 '
				}, {
					x: '389 ',
					y: '555 '
				}, {
					x: '381 ',
					y: '532 '
				}, {
					x: '372 ',
					y: '555 '
				}, {
					x: '327 ',
					y: '562 '
				}, {
					x: '283 ',
					y: '542 '
				}, {
					x: '293 ',
					y: '464 '
				}
			],
			waist: [{
					x: '326 ',
					y: '335 '
				}, {
					x: '444 ',
					y: '335 '
				}, {
					x: '439 ',
					y: '363 '
				}, {
					x: '468 ',
					y: '457 '
				}, {
					x: '380 ',
					y: '470 '
				}, {
					x: '293 ',
					y: '459 '
				}, {
					x: '327 ',
					y: '372 '
				}, {
					x: '326 ',
					y: '335 '
				}
			]
		},
		symptomList: [{
				"PositionName": "全身症状",
				"HumanSymptomList": [{
						"SymptomID": 639,
						"SymptomName": "低热"
					}, {
						"SymptomID": 888,
						"SymptomName": "发烧"
					}, {
						"SymptomID": 2403,
						"SymptomName": "溃疡"
					}, {
						"SymptomID": 2633,
						"SymptomName": "麻痹"
					}, {
						"SymptomID": 2852,
						"SymptomName": "囊肿"
					}, {
						"SymptomID": 4083,
						"SymptomName": "嗜睡"
					}, {
						"SymptomID": 323,
						"SymptomName": "脾气变坏"
					}, {
						"SymptomID": 4081,
						"SymptomName": "嗜酒"
					}, {
						"SymptomID": 3980,
						"SymptomName": "失眠"
					}, {
						"SymptomID": 5312,
						"SymptomName": "休克"
					}, {
						"SymptomID": 6067,
						"SymptomName": "胀痛"
					}, {
						"SymptomID": 1670,
						"SymptomName": "昏迷"
					}, {
						"SymptomID": 898,
						"SymptomName": "发炎"
					}, {
						"SymptomID": 4860,
						"SymptomName": "喜凉怕热"
					}, {
						"SymptomID": 4249,
						"SymptomName": "水肿"
					}, {
						"SymptomID": 3266,
						"SymptomName": "疲劳"
					}, {
						"SymptomID": 6751,
						"SymptomName": "暴瘦"
					}, {
						"SymptomID": 4034,
						"SymptomName": "食物过敏"
					}, {
						"SymptomID": 462,
						"SymptomName": "抽筋"
					}, {
						"SymptomID": 3867,
						"SymptomName": "神经痛"
					}, {
						"SymptomID": 461,
						"SymptomName": "抽风"
					}, {
						"SymptomID": 4199,
						"SymptomName": "衰弱"
					}, {
						"SymptomID": 459,
						"SymptomName": "抽搐"
					}, {
						"SymptomID": 4239,
						"SymptomName": "水泡"
					}, {
						"SymptomID": 354,
						"SymptomName": "颤抖"
					}, {
						"SymptomID": 4382,
						"SymptomName": "瘫痪"
					}, {
						"SymptomID": 516,
						"SymptomName": "猝死"
					}, {
						"SymptomID": 4777,
						"SymptomName": "无力"
					}, {
						"SymptomID": 898,
						"SymptomName": "发炎"
					}, {
						"SymptomID": 4830,
						"SymptomName": "息肉"
					}, {
						"SymptomID": 787,
						"SymptomName": "恶寒"
					}, {
						"SymptomID": 5321,
						"SymptomName": "虚脱"
					}, {
						"SymptomID": 1380,
						"SymptomName": "骨裂"
					}, {
						"SymptomID": 6536,
						"SymptomName": "虚胖"
					}, {
						"SymptomID": 1472,
						"SymptomName": "过早衰老"
					}, {
						"SymptomID": 6748,
						"SymptomName": "血管堵塞"
					}, {
						"SymptomID": 1673,
						"SymptomName": "浑身酸痛"
					}, {
						"SymptomID": 5788,
						"SymptomName": "抑郁"
					}, {
						"SymptomID": 6683,
						"SymptomName": "浑身发冷"
					}, {
						"SymptomID": 5914,
						"SymptomName": "营养不良"
					}, {
						"SymptomID": 3296,
						"SymptomName": "贫血"
					}, {
						"SymptomID": 6262,
						"SymptomName": "中暑"
					}, {
						"SymptomID": 489,
						"SymptomName": "创伤"
					}, {
						"SymptomID": 421,
						"SymptomName": "痴呆"
					}, {
						"SymptomID": 763,
						"SymptomName": "多疑"
					}, {
						"SymptomID": 801,
						"SymptomName": "噩梦"
					}, {
						"SymptomID": 911,
						"SymptomName": "乏力"
					}, {
						"SymptomID": 6486,
						"SymptomName": "肥胖"
					}, {
						"SymptomID": 915,
						"SymptomName": "烦躁不安"
					}, {
						"SymptomID": 1285,
						"SymptomName": "高血压"
					}, {
						"SymptomID": 4981,
						"SymptomName": "消瘦"
					}, {
						"SymptomID": 5717,
						"SymptomName": "夜游症"
					}, {
						"SymptomID": 6109,
						"SymptomName": "知觉消失"
					}, {
						"SymptomID": 6379,
						"SymptomName": "自恋"
					}
				]
			}, {
				"PositionName": "皮肤症状",
				"HumanSymptomList": [{
						"SymptomID": 463,
						"SymptomName": "臭汗"
					}, {
						"SymptomID": 37,
						"SymptomName": "白头粉刺"
					}, {
						"SymptomID": 4403,
						"SymptomName": "烫伤"
					}, {
						"SymptomID": 466,
						"SymptomName": "出冷汗"
					}, {
						"SymptomID": 973,
						"SymptomName": "肥胖纹"
					}, {
						"SymptomID": 1147,
						"SymptomName": "干性皮肤"
					}, {
						"SymptomID": 1646,
						"SymptomName": "黄疸"
					}, {
						"SymptomID": 3111,
						"SymptomName": "疱疹"
					}, {
						"SymptomID": 5358,
						"SymptomName": "血痂"
					}, {
						"SymptomID": 6368,
						"SymptomName": "紫斑"
					}, {
						"SymptomID": 6517,
						"SymptomName": "灼痛"
					}, {
						"SymptomID": 3722,
						"SymptomName": "瘙痒"
					}, {
						"SymptomID": 87,
						"SymptomName": "斑疹"
					}, {
						"SymptomID": 3477,
						"SymptomName": "轻度烧伤"
					}, {
						"SymptomID": 714,
						"SymptomName": "冻疮"
					}, {
						"SymptomID": 3254,
						"SymptomName": "皮炎"
					}, {
						"SymptomID": 2213,
						"SymptomName": "剧痒"
					}, {
						"SymptomID": 4575,
						"SymptomName": "脱皮"
					}, {
						"SymptomID": 626,
						"SymptomName": "盗汗"
					}, {
						"SymptomID": 3997,
						"SymptomName": "湿疹"
					}, {
						"SymptomID": 701,
						"SymptomName": "冬季皮肤瘙痒"
					}, {
						"SymptomID": 4164,
						"SymptomName": "手足脱皮"
					}, {
						"SymptomID": 1469,
						"SymptomName": "过敏性皮炎"
					}, {
						"SymptomID": 4773,
						"SymptomName": "无胡须腋毛和阴毛"
					}, {
						"SymptomID": 1147,
						"SymptomName": "干性皮肤"
					}, {
						"SymptomID": 1961,
						"SymptomName": "结痂"
					}, {
						"SymptomID": 2779,
						"SymptomName": "面色灰暗"
					}, {
						"SymptomID": 3024,
						"SymptomName": "脓包"
					}, {
						"SymptomID": 3031,
						"SymptomName": "脓疱"
					}, {
						"SymptomID": 3138,
						"SymptomName": "皮肤苍白"
					}, {
						"SymptomID": 3143,
						"SymptomName": "皮肤出现硬块"
					}, {
						"SymptomID": 3148,
						"SymptomName": "皮肤粗糙"
					}, {
						"SymptomID": 3164,
						"SymptomName": "皮肤干燥"
					}, {
						"SymptomID": 3168,
						"SymptomName": "皮肤过敏"
					}, {
						"SymptomID": 3181,
						"SymptomName": "皮肤皲裂"
					}, {
						"SymptomID": 3195,
						"SymptomName": "皮肤搔痒"
					}, {
						"SymptomID": 6496,
						"SymptomName": "皮疹"
					}, {
						"SymptomID": 3218,
						"SymptomName": "皮肤油腻"
					}, {
						"SymptomID": 3570,
						"SymptomName": "雀斑"
					}
				]
			}, {
				"PositionName": "口腔",
				"HumanSymptomList": [{
						"SymptomID": 6597,
						"SymptomName": "舌头溃疡"
					}, {
						"SymptomID": 109,
						"SymptomName": "暴牙"
					}, {
						"SymptomID": 2308,
						"SymptomName": "口臭"
					}, {
						"SymptomID": 6865,
						"SymptomName": "舌头起泡"
					}, {
						"SymptomID": 6888,
						"SymptomName": "嘴唇干裂"
					}, {
						"SymptomID": 2331,
						"SymptomName": "口干渴难忍"
					}, {
						"SymptomID": 509,
						"SymptomName": "唇周边长痘"
					}, {
						"SymptomID": 527,
						"SymptomName": "打哈欠"
					}, {
						"SymptomID": 2185,
						"SymptomName": "咀嚼肌肥大"
					}, {
						"SymptomID": 2337,
						"SymptomName": "口角生疮"
					}, {
						"SymptomID": 2575,
						"SymptomName": "流涎"
					}, {
						"SymptomID": 2793,
						"SymptomName": "磨牙"
					}, {
						"SymptomID": 5476,
						"SymptomName": "牙痛"
					}, {
						"SymptomID": 6888,
						"SymptomName": "嘴唇干裂"
					}
				]
			}, {
				"PositionName": "眼睛",
				"HumanSymptomList": [{
						"SymptomID": 1996,
						"SymptomName": "近视散光"
					}, {
						"SymptomID": 2573,
						"SymptomName": "流泪"
					}, {
						"SymptomID": 2812,
						"SymptomName": "目光呆滞"
					}, {
						"SymptomID": 5556,
						"SymptomName": "眼干"
					}, {
						"SymptomID": 6681,
						"SymptomName": "视力下降"
					}, {
						"SymptomID": 560,
						"SymptomName": "呆滞"
					}, {
						"SymptomID": 6678,
						"SymptomName": "视物模糊"
					}, {
						"SymptomID": 587,
						"SymptomName": "单眼失明"
					}, {
						"SymptomID": 4459,
						"SymptomName": "瞳孔变形"
					}, {
						"SymptomID": 1531,
						"SymptomName": "红色盲"
					}, {
						"SymptomID": 6868,
						"SymptomName": "瞳孔放大"
					}, {
						"SymptomID": 1545,
						"SymptomName": "虹膜发炎"
					}, {
						"SymptomID": 5543,
						"SymptomName": "眼部感染"
					}, {
						"SymptomID": 1916,
						"SymptomName": "角膜溃疡"
					}, {
						"SymptomID": 5556,
						"SymptomName": "眼干"
					}, {
						"SymptomID": 1925,
						"SymptomName": "角膜炎"
					}, {
						"SymptomID": 5626,
						"SymptomName": "眼痛"
					}
				]
			}, {
				"PositionName": "鼻子",
				"HumanSymptomList": [{
						"SymptomID": 133,
						"SymptomName": "鼻出血"
					}, {
						"SymptomID": 180,
						"SymptomName": "鼻塞"
					}, {
						"SymptomID": 156,
						"SymptomName": "鼻孔流脓"
					}, {
						"SymptomID": 145,
						"SymptomName": "鼻干"
					}, {
						"SymptomID": 100,
						"SymptomName": "鼻痒"
					}, {
						"SymptomID": 6640,
						"SymptomName": "鼻酸"
					}, {
						"SymptomID": 6634,
						"SymptomName": "鼻翼发红"
					}
				]
			}, {
				"PositionName": "耳朵",
				"HumanSymptomList": [{
						"SymptomID": 747,
						"SymptomName": "对声音敏感"
					}, {
						"SymptomID": 862,
						"SymptomName": "耳聋"
					}, {
						"SymptomID": 838,
						"SymptomName": "耳冻伤"
					}, {
						"SymptomID": 6650,
						"SymptomName": "耳后长包"
					}, {
						"SymptomID": 6890,
						"SymptomName": "耳朵脱皮"
					}, {
						"SymptomID": 6817,
						"SymptomName": "耳朵长痘"
					}, {
						"SymptomID": 4441,
						"SymptomName": "听觉疲劳"
					}, {
						"SymptomID": 1637,
						"SymptomName": "幻听"
					}, {
						"SymptomID": 830,
						"SymptomName": "耳垂小"
					}, {
						"SymptomID": 827,
						"SymptomName": "耳垂过大"
					}, {
						"SymptomID": 841,
						"SymptomName": "耳根部疼痛"
					}, {
						"SymptomID": 849,
						"SymptomName": "耳后疼痛"
					}, {
						"SymptomID": 866,
						"SymptomName": "耳鸣"
					}
				]
			}, {
				"PositionName": "头部",
				"HumanSymptomList": [{
						"SymptomID": 4379,
						"SymptomName": "太阳穴胀痛"
					}, {
						"SymptomID": 2757,
						"SymptomName": "面部麻木"
					}, {
						"SymptomID": 1529,
						"SymptomName": "红赤面"
					}, {
						"SymptomID": 4520,
						"SymptomName": "头晕"
					}
				]
			}, {
				"PositionName": "咽喉",
				"HumanSymptomList": [{
						"SymptomID": 6485,
						"SymptomName": "扁桃体发炎"
					}, {
						"SymptomID": 1310,
						"SymptomName": "梗噎"
					}, {
						"SymptomID": 1553,
						"SymptomName": "喉部刺痛"
					}, {
						"SymptomID": 1555,
						"SymptomName": "喉部痉挛"
					}, {
						"SymptomID": 1564,
						"SymptomName": "喉咙痒"
					}, {
						"SymptomID": 1563,
						"SymptomName": "喉咙痛"
					}, {
						"SymptomID": 3720,
						"SymptomName": "嗓音粗"
					}, {
						"SymptomID": 3972,
						"SymptomName": "声门短而窄"
					}, {
						"SymptomID": 1561,
						"SymptomName": "喉结增大"
					}, {
						"SymptomID": 1569,
						"SymptomName": "喉头水肿"
					}, {
						"SymptomID": 1571,
						"SymptomName": "喉痒咳嗽"
					}, {
						"SymptomID": 1557,
						"SymptomName": "喉部有痰"
					}, {
						"SymptomID": 3720,
						"SymptomName": "嗓音粗"
					}, {
						"SymptomID": 3977,
						"SymptomName": "声音嘶哑"
					}, {
						"SymptomID": 3979,
						"SymptomName": "失读"
					}, {
						"SymptomID": 1825,
						"SymptomName": "甲状腺肿大"
					}, {
						"SymptomID": 6488,
						"SymptomName": "甲状腺结节"
					}

				]
			}, {
				"PositionName": "颈椎",
				"HumanSymptomList": [{
						"SymptomID": 308,
						"SymptomName": "不能转颈"
					}, {
						"SymptomID": 290,
						"SymptomName": "脖子扭痛"
					}, {
						"SymptomID": 732,
						"SymptomName": "短颈"
					}, {
						"SymptomID": 2116,
						"SymptomName": "颈椎痛"
					}, {
						"SymptomID": 2069,
						"SymptomName": "颈背疼痛"
					}, {
						"SymptomID": 2072,
						"SymptomName": "颈部潮红"
					}, {
						"SymptomID": 6603,
						"SymptomName": "颈椎反弓"
					}, {
						"SymptomID": 6551,
						"SymptomName": "颈部肿瘤"
					}, {
						"SymptomID": 2626,
						"SymptomName": "落枕"
					}, {
						"SymptomID": 2109,
						"SymptomName": "颈椎变形"
					}, {
						"SymptomID": 2080,
						"SymptomName": "颈部扭伤"
					}
				]
			}, {
				"PositionName": "肺",
				"HumanSymptomList": [{
						"SymptomID": 2284,
						"SymptomName": "咳血"
					}, {
						"SymptomID": 1595,
						"SymptomName": "呼吸衰竭"
					}, {
						"SymptomID": 927,
						"SymptomName": "反复肺炎"
					}, {
						"SymptomID": 980,
						"SymptomName": "肺部感染"
					}, {
						"SymptomID": 6856,
						"SymptomName": "肺部疼痛"
					}
				]
			}, {
				"PositionName": "心脏",
				"HumanSymptomList": [{
						"SymptomID": 5095,
						"SymptomName": "心慌"
					}, {
						"SymptomID": 5126,
						"SymptomName": "心力衰竭"
					}, {
						"SymptomID": 5129,
						"SymptomName": "心率不齐"
					}, {
						"SymptomID": 5131,
						"SymptomName": "心率增快"
					}, {
						"SymptomID": 5130,
						"SymptomName": "心率过缓"
					}, {
						"SymptomID": 5180,
						"SymptomName": "心脏骤停"
					}
				]

			}, {
				"PositionName": "呼吸道",
				"HumanSymptomList": [{
						"SymptomID": 1141,
						"SymptomName": "干咳"
					}, {
						"SymptomID": 2274,
						"SymptomName": "咳嗽"
					}, {
						"SymptomID": 3504,
						"SymptomName": "情绪性哮喘"
					}, {
						"SymptomID": 487,
						"SymptomName": "喘息"
					}, {
						"SymptomID": 928,
						"SymptomName": "反复感冒"
					}, {
						"SymptomID": 3344,
						"SymptomName": "气短"
					}, {
						"SymptomID": 3339,
						"SymptomName": "气喘"
					}, {
						"SymptomID": 3358,
						"SymptomName": "气急"
					}, {
						"SymptomID": 4819,
						"SymptomName": "吸气困难"
					}, {
						"SymptomID": 4978,
						"SymptomName": "消化道狭窄"
					}
				]

			}, {
				"PositionName": "肝",
				"HumanSymptomList": [{
						"SymptomID": 1154,
						"SymptomName": "肝部疼痛"
					}, {
						"SymptomID": 1184,
						"SymptomName": "肝气郁结"
					}, {
						"SymptomID": 1165,
						"SymptomName": "肝功能异常"
					}
				]

			}, {
				"PositionName": "胃",
				"HumanSymptomList": [{
						"SymptomID": 110,
						"SymptomName": "暴饮暴食"
					}, {
						"SymptomID": 938,
						"SymptomName": "反胃"
					}, {
						"SymptomID": 792,
						"SymptomName": "恶心"
					}, {
						"SymptomID": 6477,
						"SymptomName": "呕吐"
					}, {
						"SymptomID": 1133,
						"SymptomName": "腹胀"
					}, {
						"SymptomID": 1130,
						"SymptomName": "腹泻"
					}, {
						"SymptomID": 4700,
						"SymptomName": "胃部隐痛"
					}, {
						"SymptomID": 4720,
						"SymptomName": "胃痉挛"
					}, {
						"SymptomID": 4744,
						"SymptomName": "胃痛"
					}, {
						"SymptomID": 4717,
						"SymptomName": "胃寒疼痛"
					}, {
						"SymptomID": 4741,
						"SymptomName": "胃酸过多"
					}, {
						"SymptomID": 6878,
						"SymptomName": "上吐下泻"
					}, {
						"SymptomID": 6479,
						"SymptomName": "干呕"
					}, {
						"SymptomID": 2407,
						"SymptomName": "溃疡疼痛"
					}, {
						"SymptomID": 6490,
						"SymptomName": "反酸"
					}, {
						"SymptomID": 613,
						"SymptomName": "胆汁返流"
					}
				]

			}, {
				"PositionName": "肠",
				"HumanSymptomList": [{
						"SymptomID": 381,
						"SymptomName": "肠痉挛"
					}, {
						"SymptomID": 399,
						"SymptomName": "肠胀气"
					}, {
						"SymptomID": 384,
						"SymptomName": "肠鸣"
					}, {
						"SymptomID": 6083,
						"SymptomName": "阵发性肠绞痛"
					}, {
						"SymptomID": 432,
						"SymptomName": "持续性肠绞痛"
					}
				]

			}, {
				"PositionName": "肾",
				"HumanSymptomList": [{
						"SymptomID": 3897,
						"SymptomName": "肾结石"
					}, {
						"SymptomID": 3902,
						"SymptomName": "肾气虚"
					}, {
						"SymptomID": 3892,
						"SymptomName": "肾功能衰竭"
					}, {
						"SymptomID": 3915,
						"SymptomName": "肾衰竭"
					}, {
						"SymptomID": 6572,
						"SymptomName": "肾痛"
					}, {
						"SymptomID": 3943,
						"SymptomName": "肾脏破裂"
					}
				]
			}, {
				"PositionName": "胸部",
				"HumanSymptomList": [{
						"SymptomID": 294,
						"SymptomName": "不典型胸痛"
					}, {
						"SymptomID": 2510,
						"SymptomName": "连枷胸"
					}, {
						"SymptomID": 2476,
						"SymptomName": "肋痛"
					}, {
						"SymptomID": 2470,
						"SymptomName": "肋骨痛"
					}, {
						"SymptomID": 3243,
						"SymptomName": "皮下气肿"
					}, {
						"SymptomID": 3363,
						"SymptomName": "气胸"
					}, {
						"SymptomID": 2196,
						"SymptomName": "巨乳"
					}, {
						"SymptomID": 5277,
						"SymptomName": "胸闷"
					}, {
						"SymptomID": 6574,
						"SymptomName": "胸闷气短"
					}, {
						"SymptomID": 5278,
						"SymptomName": "胸闷憋气"
					}, {
						"SymptomID": 57,
						"SymptomName": "侧肋骨痛"
					}, {
						"SymptomID": 6451,
						"SymptomName": "左胸痛"
					}, {
						"SymptomID": 5979,
						"SymptomName": "右胸痛"
					}, {
						"SymptomID": 754,
						"SymptomName": "多根肋骨骨折"
					}, {
						"SymptomID": 6241,
						"SymptomName": "窒息"
					}
				]

			}, {
				"PositionName": "腰腹部",
				"HumanSymptomList": [{
						"SymptomID": 6480,
						"SymptomName": "腰痛"
					}, {
						"SymptomID": 5657,
						"SymptomName": "腰背痛"
					}, {
						"SymptomID": 2426,
						"SymptomName": "阑尾脓肿"
					}, {
						"SymptomID": 5654,
						"SymptomName": "腰背刺痛"
					}, {
						"SymptomID": 5656,
						"SymptomName": "腰背酸痛"
					}, {
						"SymptomID": 2114,
						"SymptomName": "颈椎间盘突出"
					}, {
						"SymptomID": 3267,
						"SymptomName": "啤酒肚"
					}, {
						"SymptomID": 6543,
						"SymptomName": "腰椎疼痛"
					}, {
						"SymptomID": 6438,
						"SymptomName": "左、右腰腹痛"
					}, {
						"SymptomID": 3279,
						"SymptomName": "脾虚"
					}, {
						"SymptomID": 2425,
						"SymptomName": "阑尾感染"
					}, {
						"SymptomID": 6257,
						"SymptomName": "中上腹痛"
					}, {
						"SymptomID": 4896,
						"SymptomName": "下腹疼痛"
					}, {
						"SymptomID": 4897,
						"SymptomName": "下腹痛"
					}, {
						"SymptomID": 4898,
						"SymptomName": "下腹胀痛"
					}, {
						"SymptomID": 4893,
						"SymptomName": "下腹绞痛"
					}, {
						"SymptomID": 1087,
						"SymptomName": "腹部不适"
					}
				]

			}, {
				"PositionName": "上肢",
				"HumanSymptomList": [{
						"SymptomID": 246,
						"SymptomName": "臂痛"
					}, {
						"SymptomID": 6581,
						"SymptomName": "胳膊疼痛"
					}, {
						"SymptomID": 426,
						"SymptomName": "持物不稳"
					}, {
						"SymptomID": 6858,
						"SymptomName": "手指淤血"
					}, {
						"SymptomID": 6571,
						"SymptomName": "手臂发麻"
					}, {
						"SymptomID": 4882,
						"SymptomName": "下垂肩"
					}, {
						"SymptomID": 6305,
						"SymptomName": "肘痛"
					}, {
						"SymptomID": 4154,
						"SymptomName": "手指扭伤"
					}, {
						"SymptomID": 4103,
						"SymptomName": "手抽筋"
					}, {
						"SymptomID": 4112,
						"SymptomName": "手麻"
					}, {
						"SymptomID": 6774,
						"SymptomName": "指甲脱落"
					}, {
						"SymptomID": 4141,
						"SymptomName": "手震颤"
					}, {
						"SymptomID": 6204,
						"SymptomName": "指甲夹伤"
					}, {
						"SymptomID": 4142,
						"SymptomName": "手指不能屈伸"
					}, {
						"SymptomID": 577,
						"SymptomName": "单纯骨折"
					}, {
						"SymptomID": 4155,
						"SymptomName": "手指痛风"
					}, {
						"SymptomID": 1861,
						"SymptomName": "肩关节痛"
					}, {
						"SymptomID": 6836,
						"SymptomName": "食指发麻"
					}, {
						"SymptomID": 1870,
						"SymptomName": "肩痛"
					}, {
						"SymptomID": 6840,
						"SymptomName": "手背长斑"
					}, {
						"SymptomID": 1795,
						"SymptomName": "季节性手脱皮"
					}, {
						"SymptomID": 6852,
						"SymptomName": "手腕骨折"
					}, {
						"SymptomID": 4107,
						"SymptomName": "手冻伤"
					}, {
						"SymptomID": 6857,
						"SymptomName": "手指僵硬"
					}, {
						"SymptomID": 4111,
						"SymptomName": "手凉"
					}, {
						"SymptomID": 4641,
						"SymptomName": "腕部疼痛"
					}, {
						"SymptomID": 4121,
						"SymptomName": "手酸"
					}, {
						"SymptomID": 4123,
						"SymptomName": "手脱皮"
					}
				]
			}, {
				"PositionName": "下肢",
				"HumanSymptomList": [{
						"SymptomID": 225,
						"SymptomName": "扁平足"
					}, {
						"SymptomID": 18,
						"SymptomName": "八字脚步态"
					}, {
						"SymptomID": 2800,
						"SymptomName": "拇外翻"
					}, {
						"SymptomID": 6616,
						"SymptomName": "腿痛"
					}, {
						"SymptomID": 6876,
						"SymptomName": "腿脚发麻"
					}, {
						"SymptomID": 4543,
						"SymptomName": "腿脚抽筋"
					}, {
						"SymptomID": 4930,
						"SymptomName": "下肢无力"
					}, {
						"SymptomID": 5048,
						"SymptomName": "小腿酸痛"
					}, {
						"SymptomID": 1937,
						"SymptomName": "脚底干裂"
					}, {
						"SymptomID": 6653,
						"SymptomName": "出脚汗"
					}, {
						"SymptomID": 304,
						"SymptomName": "不能屈膝"
					}, {
						"SymptomID": 4838,
						"SymptomName": "膝盖撞伤"
					}, {
						"SymptomID": 549,
						"SymptomName": "大腿刺痛"
					}, {
						"SymptomID": 4887,
						"SymptomName": "下蹲困难"
					}, {
						"SymptomID": 553,
						"SymptomName": "大腿外侧痛"
					}, {
						"SymptomID": 1727,
						"SymptomName": "鸡眼"
					}, {
						"SymptomID": 6540,
						"SymptomName": "大腿酸痛"
					}, {
						"SymptomID": 1936,
						"SymptomName": "脚臭"
					}, {
						"SymptomID": 6547,
						"SymptomName": "大腿内侧痛"
					}, {
						"SymptomID": 1940,
						"SymptomName": "脚气"
					}, {
						"SymptomID": 6549,
						"SymptomName": "大腿内侧瘙痒"
					}, {
						"SymptomID": 6756,
						"SymptomName": "脚痒"
					}, {
						"SymptomID": 6553,
						"SymptomName": "大腿疼痛"
					}, {
						"SymptomID": 1937,
						"SymptomName": "脚底干裂"
					}, {
						"SymptomID": 5046,
						"SymptomName": "小腿瘙痒干燥"
					}, {
						"SymptomID": 1938,
						"SymptomName": "脚冻伤"
					}, {
						"SymptomID": 5047,
						"SymptomName": "小腿水肿"
					}, {
						"SymptomID": 6409,
						"SymptomName": "足底脱皮"
					}, {
						"SymptomID": 6835,
						"SymptomName": "小腿乏力"
					}, {
						"SymptomID": 6423,
						"SymptomName": "足癣"
					}
				]
			}, {
				"PositionName": "背部",
				"HumanSymptomList": [{
						"SymptomID": 116,
						"SymptomName": "背部痉挛"
					}, {
						"SymptomID": 6758,
						"SymptomName": "背胀"
					}, {
						"SymptomID": 117,
						"SymptomName": "背部酸痛"
					}, {
						"SymptomID": 119,
						"SymptomName": "背脊痛"
					}, {
						"SymptomID": 120,
						"SymptomName": "背痛"
					}, {
						"SymptomID": 4580,
						"SymptomName": "驼背"
					}
				]
			}, {
				"PositionName": "排泄部",
				"HumanSymptomList": [{
						"SymptomID": 232,
						"SymptomName": "便秘"
					}, {
						"SymptomID": 6607,
						"SymptomName": "大便干燥"
					}, {
						"SymptomID": 555,
						"SymptomName": "大小便失禁"
					}, {
						"SymptomID": 4574,
						"SymptomName": "脱肛"
					}, {
						"SymptomID": 1236,
						"SymptomName": "肛门剧痛"
					}, {
						"SymptomID": 1227,
						"SymptomName": "肛裂"
					}, {
						"SymptomID": 1230,
						"SymptomName": "肛门病变"
					}, {
						"SymptomID": 1246,
						"SymptomName": "肛门坠胀"
					}, {
						"SymptomID": 1042,
						"SymptomName": "粪便量多"
					}, {
						"SymptomID": 3104,
						"SymptomName": "排气障碍"
					}, {
						"SymptomID": 1043,
						"SymptomName": "粪便量少"
					}, {
						"SymptomID": 1241,
						"SymptomName": "肛门外翻"
					}, {
						"SymptomID": 1239,
						"SymptomName": "肛门松弛"
					}, {
						"SymptomID": 1684,
						"SymptomName": "肛门瘙痒"
					}, {
						"SymptomID": 6238,
						"SymptomName": "痔出血"
					}, {
						"SymptomID": 3088,
						"SymptomName": "排便困难"
					}, {
						"SymptomID": 3091,
						"SymptomName": "排便障碍"
					}, {
						"SymptomID": 3090,
						"SymptomName": "排便时间过长"
					}, {
						"SymptomID": 3092,
						"SymptomName": "排出结石"
					}, {
						"SymptomID": 3103,
						"SymptomName": "排气多"
					}
				]
			}, {
				"PositionName": "男性生殖",
				"HumanSymptomList": [{
						"SymptomID": 2834,
						"SymptomName": "男性不育"
					}, {
						"SymptomID": 2840,
						"SymptomName": "男性性早熟"
					}, {
						"SymptomID": 6510,
						"SymptomName": "包皮水肿"
					}, {
						"SymptomID": 6732,
						"SymptomName": "包皮红肿"
					}, {
						"SymptomID": 1291,
						"SymptomName": "睾丸发育不全"
					}, {
						"SymptomID": 1293,
						"SymptomName": "睾丸疼痛"
					}, {
						"SymptomID": 3403,
						"SymptomName": "前列腺结石"
					}, {
						"SymptomID": 5871,
						"SymptomName": "隐睾"
					}, {
						"SymptomID": 6521,
						"SymptomName": "阴囊潮湿"
					}, {
						"SymptomID": 5848,
						"SymptomName": "阴茎疼痛"
					}, {
						"SymptomID": 5763,
						"SymptomName": "遗精"
					}, {
						"SymptomID": 2065,
						"SymptomName": "精子稀少"
					}, {
						"SymptomID": 2053,
						"SymptomName": "精液稠"
					}, {
						"SymptomID": 6734,
						"SymptomName": "包皮开裂"
					}, {
						"SymptomID": 5857,
						"SymptomName": "阴囊水肿"
					}, {
						"SymptomID": 1290,
						"SymptomName": "睾丸触痛"
					}, {
						"SymptomID": 5860,
						"SymptomName": "阴囊肿胀"
					}, {
						"SymptomID": 1297,
						"SymptomName": "睾丸胀痛"
					}, {
						"SymptomID": 5850,
						"SymptomName": "阴茎异常"
					}, {
						"SymptomID": 2055,
						"SymptomName": "精液发黄"
					}, {
						"SymptomID": 2056,
						"SymptomName": "精液量多"
					}, {
						"SymptomID": 2057,
						"SymptomName": "精液少"
					}, {
						"SymptomID": 2065,
						"SymptomName": "精子稀少"
					}, {
						"SymptomID": 2062,
						"SymptomName": "精子活力低"
					}, {
						"SymptomID": 2067,
						"SymptomName": "精子质量下降"
					}, {
						"SymptomID": 2836,
						"SymptomName": "男性小便刺痛"
					}, {
						"SymptomID": 3835,
						"SymptomName": "射精疼"
					}, {
						"SymptomID": 6794,
						"SymptomName": "前列腺快感"
					}, {
						"SymptomID": 4175,
						"SymptomName": "输精管疼痛"
					}
				]
			}, {
				"PositionName": "女性生殖",
				"HumanSymptomList": [{
						"SymptomID": 759,
						"SymptomName": "多囊卵巢"
					}, {
						"SymptomID": 345,
						"SymptomName": "产后子宫收缩"
					}, {
						"SymptomID": 28,
						"SymptomName": "白带增多"
					}, {
						"SymptomID": 6483,
						"SymptomName": "白带异常"
					}, {
						"SymptomID": 1332,
						"SymptomName": "宫腔积脓"
					}, {
						"SymptomID": 1320,
						"SymptomName": "宫颈闭锁"
					}, {
						"SymptomID": 1666,
						"SymptomName": "会阴部撕裂感"
					}, {
						"SymptomID": 2619,
						"SymptomName": "卵巢性多毛"
					}, {
						"SymptomID": 2570,
						"SymptomName": "流产"
					}, {
						"SymptomID": 2615,
						"SymptomName": "卵巢功能障碍"
					}, {
						"SymptomID": 4472,
						"SymptomName": "痛经"
					}, {
						"SymptomID": 4447,
						"SymptomName": "停经"
					}, {
						"SymptomID": 5979,
						"SymptomName": "月经量多"
					}, {
						"SymptomID": 6346,
						"SymptomName": "子宫穿孔"
					}, {
						"SymptomID": 6502,
						"SymptomName": "月经推迟"
					}, {
						"SymptomID": 3044,
						"SymptomName": "女性不孕"
					}, {
						"SymptomID": 6484,
						"SymptomName": "月经不调"
					}, {
						"SymptomID": 4177,
						"SymptomName": "输卵管肿大"
					}, {
						"SymptomID": 6586,
						"SymptomName": "白带带血"
					}, {
						"SymptomID": 6641,
						"SymptomName": "外阴干涩"
					}, {
						"SymptomID": 6589,
						"SymptomName": "白带异味"
					}, {
						"SymptomID": 5234,
						"SymptomName": "性交疼痛"
					}, {
						"SymptomID": 333,
						"SymptomName": "产后出血"
					}, {
						"SymptomID": 5829,
						"SymptomName": "阴道裂伤"
					}, {
						"SymptomID": 1328,
						"SymptomName": "宫颈水肿"
					}, {
						"SymptomID": 5820,
						"SymptomName": "阴道不规则出血"
					}, {
						"SymptomID": 1323,
						"SymptomName": "宫颈糜烂"
					}, {
						"SymptomID": 5824,
						"SymptomName": "阴道出血"
					}, {
						"SymptomID": 1324,
						"SymptomName": "宫颈囊肿"
					}, {
						"SymptomID": 6358,
						"SymptomName": "子宫松弛"
					}, {
						"SymptomID": 6514,
						"SymptomName": "外阴瘙痒"
					}, {
						"SymptomID": 6359,
						"SymptomName": "子宫下垂"
					}, {
						"SymptomID": 2018,
						"SymptomName": "经期提前"
					}, {
						"SymptomID": 2020,
						"SymptomName": "经期推迟"
					}, {
						"SymptomID": 2017,
						"SymptomName": "经期缩短"
					}, {
						"SymptomID": 2220,
						"SymptomName": "绝经"
					}, {
						"SymptomID": 2616,
						"SymptomName": "卵巢囊肿"
					}
				]
			}, {

				"PositionName": "膀胱",
				"HumanSymptomList": [{
						"SymptomID": 2981,
						"SymptomName": "尿频"
					}, {
						"SymptomID": 2969,
						"SymptomName": "尿急"
					}, {
						"SymptomID": 2994,
						"SymptomName": "尿痛"
					}, {
						"SymptomID": 6566,
						"SymptomName": "尿无力"
					}, {
						"SymptomID": 6673,
						"SymptomName": "尿等待"
					}
				]
			}
		]
	},
	
	getEventPosition: function (ev) { //
		var x,
		y;
		if (ev.layerX || ev.layerX == 0) {
			x = ev.layerX;
			y = ev.layerY;
		} else if (ev.offsetX || ev.offsetX == 0) { // Opera
			x = ev.offsetX;
			y = ev.offsetY;
		}
		return {
			x: x,
			y: y
		};
	},
	bindOne2Two: function () { ///一级菜单跳二级菜单
		$(".left-wrap li").on("click", function () {
			var descID;
			descID = $(this).find("a").attr("link");
			$(".left-wrap li").removeClass("active");
			$(".sickContent").removeClass("active");
			$(".left-wrap .tablinks").removeClass("active");
			// 让目的Dow添加active
			$("#" + descID).addClass("active");
			$(this).addClass("active");
			$(this).find(".tablinks").addClass("active");
			scroll_right.refresh();
			scroll_right.scrollTo(0, 0);
		})
	}, writeSymptomList: function () {
		var temp,
		$right_wrap,
		symptom,
		symptomList,
		PositionName,
		HumanSymptomList,
		idName,
		symp1to2ByCName,
		isIPhone,
		sick_list_height,
		top_tab_height = $("#top_tab").height(),
		client_height = $(window).height(),
		$sick_list = $("#sick_list"),
		$right_content = $("#right_content");
		$right_wrap = $(".right-wrap");

		//控制列表高度symp1to2ByCName
		isIPhone = window.navigator.appVersion.match(/iphone/gi);
		sick_list_height = client_height - top_tab_height;
		if (isIPhone) {
			sick_list_height = sick_list_height - 64;
		}
		$sick_list.find(".right-wrap").height(sick_list_height);
		$sick_list.find(".left-wrap").height(sick_list_height);

		symptomList = this.option.symptomList;
		symp1to2ByCName = this.option.symp1to2ByCName;
		temp = '';
		for (var i = 0; i < symptomList.length; i++) {
			PositionName = symptomList[i].PositionName;
			HumanSymptomList = symptomList[i].HumanSymptomList;
			idName = symp1to2ByCName[PositionName];
			temp += '<ul  id="' + idName + '" class="sickContent" ">'

			for (var j = 0; j < HumanSymptomList.length; j++) {
				temp += '<li><a href="#" id="' + HumanSymptomList[j].SymptomID + '">' + HumanSymptomList[j].SymptomName + '</a></li>'
			}
			temp += '</ul>'
		}
		$right_content.empty().append(temp);
		$right_content.find("#symp_body").addClass("active");
	},
	bindOrganEvent: function () {
		$(".organ_item").click(function () {
			var id = $(this).attr("id");
			id = id.substr(10);
//			var organID=$(this).parents(".organ").attr("id");
//			index.history=organID;
			var sympt_link = index.option.idTolink[id];
			index.scrollEvent(sympt_link);
			
		})
	},
	scrollEvent:function( sympt_link){
		
			var str_select = ".left-wrap li a[link='" + sympt_link + "']";
			
			$("#symp_list_a").click();
			var descID;
			descID = sympt_link;
			$(".left-wrap li").removeClass("active");
			$(".sickContent").removeClass("active");
			$(".left-wrap .tablinks").removeClass("active");
			// 让目的Dow添加active
			$("#" + descID).addClass("active");
			$(str_select).addClass("active")
			$(str_select).parent().addClass("active");
			scroll_right.refresh();
			scroll_right.scrollTo(0, 0);
			scroll_left.scrollTo(0, 0);
			
			//滚动
			var top=$(str_select).offset().top;
			var wrapHeight=$("#left_wrapper").height();
			var LiHeight=$("#left_wrapper > ul > li").height();
			for(var scrollLenght=0;top>wrapHeight;){
				top=top-10*LiHeight;
				scrollLenght=scrollLenght+10*LiHeight
				
			}
			scroll_left.scrollTo(0, -scrollLenght);
	},
	bindTurnSex: function () {
		var _this = this;
		$(".sex-btn").on("click", function () {
			var sex,
			$this,
			$groups,
			$cur_box_people;
			$this = $(this);
			$groups = $(".sex-btn");
			sex = $this.text();
			$cur_box_people = $(".box-people.active");

			$groups.removeClass("active");
			$this.addClass("active");
			//根据性别进行切换
			$cur_box_people.removeClass("active");
			if (sex == "男") {
				$("#man_front").addClass("active");

				_this.drawManFront();
			} else {
				$("#girl_front").addClass("active");
				_this.drawgirlFront();
			}

		})
	},
	bindTurnBack: function () {
		var _this = this;
		$(".turn").on("click", function () {
			var id,
			$curTarget,
			tempArr,
			newID;

			$curTarget = $(".box-people.active");
			id = $curTarget.attr("id");
			tempArr = id.split("_");

			if (tempArr[1] == "front") {
				tempArr[1] = "back"
			} else {
				tempArr[1] = "front"
			}
			newID = tempArr.join("_");

			$curTarget.removeClass("active");
			$("#" + newID).addClass("active")
			//绘制cavas
			switch (newID) {
			case "man_front":
				_this.drawManFront();
				break;
			case "man_back":
				_this.drawManBack();
				break;
			case "girl_front":
				_this.drawgirlFront();
				break;
			case "girl_back":
				_this.drawgirlBack();
				break;

			}

		});
	},
	drawManFront: function () {
			var canvas = document.getElementById('cavas_man_front');
			canvas.width = $("#wrap_cavas_man_front").width();
			canvas.height = $("#wrap_cavas_man_front").height();

			if (canvas.getContext) {

				var ctx = canvas.getContext('2d');

				//画头
				ctx.fillStyle = '#00ACEE';
				ctx.beginPath();
				ctx.moveTo(327 * rem / 100, 30 * rem / 100);
				ctx.lineTo(460 * rem / 100, 32 * rem / 100);
				ctx.lineTo(422 * rem / 100, 197 * rem / 100);
				ctx.lineTo(349 * rem / 100, 197 * rem / 100);
				ctx.lineTo(324 * rem / 100, 107 * rem / 100);
				ctx.lineTo(327 * rem / 100, 30 * rem / 100);
				//画脖子
				ctx.beginPath();
				ctx.moveTo(349 * rem / 100, 197 * rem / 100);
				ctx.lineTo(422 * rem / 100, 195 * rem / 100);
				ctx.lineTo(478 * rem / 100, 228 * rem / 100);
				ctx.lineTo(382 * rem / 100, 245 * rem / 100);
				ctx.lineTo(295 * rem / 100, 226 * rem / 100);
				ctx.lineTo(349 * rem / 100, 197 * rem / 100);
				
				//画胸部
				ctx.beginPath();
				ctx.moveTo(273 * rem / 100, 232 * rem / 100);
				ctx.lineTo(293 * rem / 100, 226 * rem / 100);
				ctx.lineTo(382 * rem / 100, 245 * rem / 100);
				ctx.lineTo(478 * rem / 100, 228 * rem / 100);
				ctx.lineTo(498 * rem / 100, 237 * rem / 100);
				ctx.lineTo(470 * rem / 100, 372 * rem / 100);
				ctx.lineTo(297 * rem / 100, 373 * rem / 100);
				ctx.lineTo(273 * rem / 100, 232 * rem / 100);
				

				//画左臂
				ctx.beginPath();
				ctx.moveTo(270 * rem / 100, 231 * rem / 100);
				ctx.lineTo(248 * rem / 100, 266 * rem / 100);
				ctx.lineTo(240 * rem / 100, 396 * rem / 100);
				ctx.lineTo(202 * rem / 100, 537 * rem / 100);
				ctx.lineTo(154 * rem / 100, 612 * rem / 100);
				ctx.lineTo(200 * rem / 100, 656 * rem / 100);
				ctx.lineTo(243 * rem / 100, 636 * rem / 100);
				ctx.lineTo(294 * rem / 100, 371 * rem / 100);
				ctx.lineTo(270 * rem / 100, 231 * rem / 100);
				

				//画右臂
				ctx.beginPath();
				ctx.moveTo(500 * rem / 100, 237 * rem / 100);
				ctx.lineTo(518 * rem / 100, 266 * rem / 100);
				ctx.lineTo(530 * rem / 100, 406 * rem / 100);
				ctx.lineTo(603 * rem / 100, 604 * rem / 100);
				ctx.lineTo(575 * rem / 100, 652 * rem / 100);
				ctx.lineTo(522 * rem / 100, 635 * rem / 100);
				ctx.lineTo(470 * rem / 100, 372 * rem / 100);
				ctx.lineTo(500 * rem / 100, 237 * rem / 100);
				
				//画腹部
				ctx.beginPath();
				ctx.moveTo(295 * rem / 100, 384 * rem / 100);
				ctx.lineTo(468 * rem / 100, 384 * rem / 100);
				ctx.lineTo(461 * rem / 100, 473 * rem / 100);
				ctx.lineTo(473 * rem / 100, 506 * rem / 100);
				ctx.lineTo(380 * rem / 100, 520 * rem / 100);
				ctx.lineTo(297 * rem / 100, 506 * rem / 100);
				ctx.lineTo(306 * rem / 100, 472 * rem / 100);
				ctx.lineTo(295 * rem / 100, 384 * rem / 100);
				
				//画生殖器
				ctx.beginPath();
				ctx.moveTo(294 * rem / 100, 505 * rem / 100);
				ctx.lineTo(379 * rem / 100, 519 * rem / 100);
				ctx.lineTo(473 * rem / 100, 505 * rem / 100);
				ctx.lineTo(487 * rem / 100, 611 * rem / 100);
				ctx.lineTo(382 * rem / 100, 624 * rem / 100);
				ctx.lineTo(284 * rem / 100, 609 * rem / 100);
				ctx.lineTo(294 * rem / 100, 505 * rem / 100);
				
				//画大腿
				ctx.beginPath();
				ctx.moveTo(284 * rem / 100, 609 * rem / 100);
				ctx.lineTo(382 * rem / 100, 624 * rem / 100);
				ctx.lineTo(487 * rem / 100, 611 * rem / 100);
				ctx.lineTo(464 * rem / 100, 798 * rem / 100);
				ctx.lineTo(457 * rem / 100, 1056 * rem / 100);
				ctx.lineTo(310 * rem / 100, 1056 * rem / 100);
				ctx.lineTo(298 * rem / 100, 807 * rem / 100);
				ctx.lineTo(284 * rem / 100, 609 * rem / 100);
				

				//画右腿

				//添加事件响应
				canvas.addEventListener('click', function (e) {
					console.info("sss")
					p = index.getEventPosition(e);
					index.reDraw(p, ctx, index.option.man_front, "man_front");
				}, false);
			}
	},
	drawManBack: function () {
		//画男人背面的cavas
		var canvas = document.getElementById('cavas_man_back');
		canvas.width = $("#wrap_cavas_man_back").width();
		canvas.height = $("#wrap_cavas_man_back").height();

		if (canvas.getContext) {
			var ctx = canvas.getContext('2d');
			console.info("rem=" + rem)
			//画头
			ctx.fillStyle = '#00ACEE';
			ctx.beginPath();
			ctx.moveTo(317 * rem / 100, 56 * rem / 100);
			ctx.lineTo(443 * rem / 100, 55 * rem / 100);
			ctx.lineTo(443 * rem / 100, 209 * rem / 100);
			ctx.lineTo(317 * rem / 100, 210 * rem / 100);
			ctx.lineTo(317 * rem / 100, 56 * rem / 100);
			//画脖子
			ctx.beginPath();
			ctx.moveTo(348 * rem / 100, 210 * rem / 100);
			ctx.lineTo(418 * rem / 100, 210 * rem / 100);
			ctx.lineTo(427 * rem / 100, 239 * rem / 100);
			ctx.lineTo(472 * rem / 100, 254 * rem / 100);
			ctx.lineTo(384 * rem / 100, 267 * rem / 100);
			ctx.lineTo(303 * rem / 100, 254 * rem / 100);
			ctx.lineTo(340 * rem / 100, 239 * rem / 100);
			ctx.lineTo(348 * rem / 100, 210 * rem / 100);
			

			//画背部
			ctx.beginPath();
			ctx.moveTo(275 * rem / 100, 256 * rem / 100);
			ctx.lineTo(300 * rem / 100, 254 * rem / 100);
			ctx.lineTo(380 * rem / 100, 271 * rem / 100);
			ctx.lineTo(473 * rem / 100, 257 * rem / 100);
			ctx.lineTo(499 * rem / 100, 264 * rem / 100);
			ctx.lineTo(476 * rem / 100, 349 * rem / 100);
			ctx.lineTo(469 * rem / 100, 403 * rem / 100);
			ctx.lineTo(296 * rem / 100, 403 * rem / 100);
			ctx.lineTo(296 * rem / 100, 352 * rem / 100);
			ctx.lineTo(275 * rem / 100, 256 * rem / 100);
			

			//画左臂
			ctx.beginPath();
			ctx.moveTo(269 * rem / 100, 262 * rem / 100);
			ctx.lineTo(251 * rem / 100, 279 * rem / 100);
			ctx.lineTo(243 * rem / 100, 385 * rem / 100);
			ctx.lineTo(202 * rem / 100, 568 * rem / 100);
			ctx.lineTo(163 * rem / 100, 641 * rem / 100);
			ctx.lineTo(195 * rem / 100, 685 * rem / 100);
			ctx.lineTo(239 * rem / 100, 670 * rem / 100);
			ctx.lineTo(243 * rem / 100, 586 * rem / 100);
			ctx.lineTo(281 * rem / 100, 498 * rem / 100);
			ctx.lineTo(296 * rem / 100, 416 * rem / 100);
			ctx.lineTo(269 * rem / 100, 262 * rem / 100);
			

			//画右臂
			ctx.beginPath();
			ctx.moveTo(502 * rem / 100, 264 * rem / 100);
			ctx.lineTo(522 * rem / 100, 284 * rem / 100);
			ctx.lineTo(522 * rem / 100, 376 * rem / 100);
			ctx.lineTo(572 * rem / 100, 560 * rem / 100);
			ctx.lineTo(606 * rem / 100, 637 * rem / 100);
			ctx.lineTo(561 * rem / 100, 676 * rem / 100);
			ctx.lineTo(522 * rem / 100, 658 * rem / 100);
			ctx.lineTo(525 * rem / 100, 590 * rem / 100);
			ctx.lineTo(472 * rem / 100, 415 * rem / 100);
			ctx.lineTo(502 * rem / 100, 264 * rem / 100);
			

			//画腰部
			ctx.beginPath();
			ctx.moveTo(296 * rem / 100, 404 * rem / 100);
			ctx.lineTo(466 * rem / 100, 406 * rem / 100);
			ctx.lineTo(472 * rem / 100, 521 * rem / 100);
			ctx.lineTo(376 * rem / 100, 533 * rem / 100);
			ctx.lineTo(296 * rem / 100, 523 * rem / 100);
			ctx.lineTo(302 * rem / 100, 490 * rem / 100);
			ctx.lineTo(296 * rem / 100, 404 * rem / 100);
			

			//画臀部
			ctx.beginPath();
			ctx.moveTo(294 * rem / 100, 531 * rem / 100);
			ctx.lineTo(378 * rem / 100, 543 * rem / 100);
			ctx.lineTo(469 * rem / 100, 531 * rem / 100);
			ctx.lineTo(485 * rem / 100, 644 * rem / 100);
			ctx.lineTo(383 * rem / 100, 643 * rem / 100);
			ctx.lineTo(325 * rem / 100, 650 * rem / 100);
			ctx.lineTo(278 * rem / 100, 648 * rem / 100);
			ctx.lineTo(283 * rem / 100, 582 * rem / 100);
			ctx.lineTo(294 * rem / 100, 531 * rem / 100);
			

			//画大腿
			ctx.beginPath();
			ctx.moveTo(279 * rem / 100, 652 * rem / 100);
			ctx.lineTo(484 * rem / 100, 649 * rem / 100);
			ctx.lineTo(458 * rem / 100, 1076 * rem / 100);
			ctx.lineTo(317 * rem / 100, 1076 * rem / 100);
			ctx.lineTo(279 * rem / 100, 652 * rem / 100);
			

			//添加事件响应
			canvas.addEventListener('click', function (e) {
				p = index.getEventPosition(e);
				index.reDraw(p, ctx, index.option.man_back, "man_back");
			}, false);
		}
	},
	drawgirlFront: function () {
		var canvas = document.getElementById('cavas_girl_front');
		canvas.width = $("#wrap_cavas_girl_front").width();
		canvas.height = $("#wrap_cavas_girl_front").height();

		if (canvas.getContext) {

			var ctx = canvas.getContext('2d');
			//画头
			ctx.beginPath();
			ctx.moveTo(350 * rem / 100, 23 * rem / 100);
			ctx.lineTo(417 * rem / 100, 23 * rem / 100);
			ctx.lineTo(421 * rem / 100, 57 * rem / 100);
			ctx.lineTo(452 * rem / 100, 91 * rem / 100);
			ctx.lineTo(453 * rem / 100, 155 * rem / 100);
			ctx.lineTo(408 * rem / 100, 199 * rem / 100);
			ctx.lineTo(364 * rem / 100, 199 * rem / 100);
			ctx.lineTo(314 * rem / 100, 150 * rem / 100);
			ctx.lineTo(318 * rem / 100, 96 * rem / 100);
			ctx.lineTo(343 * rem / 100, 59 * rem / 100);
			ctx.lineTo(350 * rem / 100, 23 * rem / 100);
			//ctx.stroke();

			//画脖子
			ctx.beginPath();
			ctx.moveTo(363 * rem / 100, 197 * rem / 100);
			ctx.lineTo(405 * rem / 100, 197 * rem / 100);
			ctx.lineTo(427 * rem / 100, 233 * rem / 100);
			ctx.lineTo(382 * rem / 100, 246 * rem / 100);
			ctx.lineTo(340 * rem / 100, 234 * rem / 100);
			ctx.lineTo(363 * rem / 100, 197 * rem / 100);
			

			//画胸部
			ctx.beginPath();
			ctx.moveTo(333 * rem / 100, 241 * rem / 100);
			ctx.lineTo(378 * rem / 100, 249 * rem / 100);
			ctx.lineTo(429 * rem / 100, 236 * rem / 100);
			ctx.lineTo(468 * rem / 100, 252 * rem / 100);
			ctx.lineTo(449 * rem / 100, 304 * rem / 100);
			ctx.lineTo(440 * rem / 100, 373 * rem / 100);
			ctx.lineTo(438 * rem / 100, 388 * rem / 100);

			ctx.lineTo(327 * rem / 100, 385 * rem / 100);
			ctx.lineTo(314 * rem / 100, 334 * rem / 100);
			ctx.lineTo(322 * rem / 100, 296 * rem / 100);
			ctx.lineTo(314 * rem / 100, 248 * rem / 100);
			ctx.lineTo(333 * rem / 100, 241 * rem / 100);
			
			//画左臂
			ctx.beginPath();
			ctx.moveTo(309 * rem / 100, 252 * rem / 100);
			ctx.lineTo(294 * rem / 100, 261 * rem / 100);
			ctx.lineTo(238 * rem / 100, 525 * rem / 100);
			ctx.lineTo(201 * rem / 100, 576 * rem / 100);
			ctx.lineTo(218 * rem / 100, 608 * rem / 100);
			ctx.lineTo(254 * rem / 100, 599 * rem / 100);
			ctx.lineTo(262 * rem / 100, 543 * rem / 100);
			ctx.lineTo(305 * rem / 100, 391 * rem / 100);
			ctx.lineTo(314 * rem / 100, 293 * rem / 100);
			ctx.lineTo(309 * rem / 100, 252 * rem / 100);
			

			//画右臂
			ctx.beginPath();
			ctx.moveTo(451 * rem / 100, 306 * rem / 100);
			ctx.lineTo(470 * rem / 100, 253 * rem / 100);
			ctx.lineTo(515 * rem / 100, 419 * rem / 100);
			ctx.lineTo(521 * rem / 100, 518 * rem / 100);
			ctx.lineTo(554 * rem / 100, 572 * rem / 100);
			ctx.lineTo(525 * rem / 100, 608 * rem / 100);
			ctx.lineTo(487 * rem / 100, 593 * rem / 100);
			ctx.lineTo(492 * rem / 100, 537 * rem / 100);
			ctx.lineTo(451 * rem / 100, 306 * rem / 100);
			

			//画腹部
			ctx.beginPath();
			ctx.moveTo(330 * rem / 100, 392 * rem / 100);
			ctx.lineTo(439 * rem / 100, 392 * rem / 100);
			ctx.lineTo(468 * rem / 100, 505 * rem / 100);
			ctx.lineTo(382 * rem / 100, 520 * rem / 100);
			ctx.lineTo(292 * rem / 100, 505 * rem / 100);
			ctx.lineTo(321 * rem / 100, 423 * rem / 100);
			ctx.lineTo(325 * rem / 100, 415 * rem / 100);
			ctx.lineTo(330 * rem / 100, 392 * rem / 100);
			

			//画生殖器
			ctx.beginPath();
			ctx.moveTo(291 * rem / 100, 506 * rem / 100);
			ctx.lineTo(379 * rem / 100, 521 * rem / 100);
			ctx.lineTo(468 * rem / 100, 506 * rem / 100);
			ctx.lineTo(475 * rem / 100, 534 * rem / 100);
			ctx.lineTo(380 * rem / 100, 569 * rem / 100);
			ctx.lineTo(288 * rem / 100, 532 * rem / 100);
			ctx.lineTo(291 * rem / 100, 506 * rem / 100);
			

			//画大腿
			ctx.beginPath();
			ctx.moveTo(286 * rem / 100, 535 * rem / 100);
			ctx.lineTo(307 * rem / 100, 1045 * rem / 100); //上中
			ctx.lineTo(454 * rem / 100, 1045 * rem / 100); //上中
			ctx.lineTo(475 * rem / 100, 535 * rem / 100); //上中
			ctx.lineTo(380 * rem / 100, 570 * rem / 100); //上中
			ctx.lineTo(286 * rem / 100, 535 * rem / 100); //上中
			

			//添加事件响应
			canvas.addEventListener('click', function (e) {
				p = index.getEventPosition(e);
				index.reDraw(p, ctx, index.option.girl_front, "girl_front");
			}, false);
		}
	},
	drawgirlBack: function () {
		//画女人背面的cavas
		var canvas = document.getElementById('cavas_girl_back');
		canvas.width = $("#wrap_cavas_girl_back").width();
		canvas.height = $("#wrap_cavas_girl_back").height();

		if (canvas.getContext) {

			var ctx = canvas.getContext('2d');

			console.info("rem=" + rem)
			//画头
			ctx.beginPath();
			ctx.moveTo(319 * rem / 100, 19 * rem / 100);
			ctx.lineTo(452 * rem / 100, 22 * rem / 100);
			ctx.lineTo(453 * rem / 100, 129 * rem / 100);
			ctx.lineTo(407 * rem / 100, 160 * rem / 100);
			ctx.lineTo(353 * rem / 100, 160 * rem / 100);
			ctx.lineTo(317 * rem / 100, 122 * rem / 100);
			ctx.lineTo(319 * rem / 100, 19 * rem / 100);
			

			//画脖子
			ctx.beginPath();
			ctx.moveTo(364 * rem / 100, 161 * rem / 100);
			ctx.lineTo(407 * rem / 100, 161 * rem / 100);
			ctx.lineTo(426 * rem / 100, 197 * rem / 100);
			ctx.lineTo(385 * rem / 100, 205 * rem / 100);
			ctx.lineTo(344 * rem / 100, 197 * rem / 100);
			ctx.lineTo(364 * rem / 100, 161 * rem / 100);
			

			//画背部
			ctx.beginPath();
			ctx.moveTo(339 * rem / 100, 202 * rem / 100);
			ctx.lineTo(384 * rem / 100, 206 * rem / 100);
			ctx.lineTo(430 * rem / 100, 202 * rem / 100);
			ctx.lineTo(466 * rem / 100, 221 * rem / 100);
			ctx.lineTo(447 * rem / 100, 266 * rem / 100);
			ctx.lineTo(454 * rem / 100, 293 * rem / 100);
			ctx.lineTo(442 * rem / 100, 333 * rem / 100);
			ctx.lineTo(382 * rem / 100, 333 * rem / 100);
			ctx.lineTo(326 * rem / 100, 333 * rem / 100);
			ctx.lineTo(314 * rem / 100, 296 * rem / 100);
			ctx.lineTo(324 * rem / 100, 269 * rem / 100);
			ctx.lineTo(314 * rem / 100, 216 * rem / 100);
			ctx.lineTo(339 * rem / 100, 202 * rem / 100);
			

			//画左臂
			ctx.beginPath();
			ctx.moveTo(310 * rem / 100, 216 * rem / 100);
			ctx.lineTo(289 * rem / 100, 237 * rem / 100);
			ctx.lineTo(238 * rem / 100, 476 * rem / 100);
			ctx.lineTo(209 * rem / 100, 528 * rem / 100);
			ctx.lineTo(212 * rem / 100, 566 * rem / 100);
			ctx.lineTo(259 * rem / 100, 566 * rem / 100);
			ctx.lineTo(311 * rem / 100, 297 * rem / 100);
			ctx.lineTo(310 * rem / 100, 216 * rem / 100);
			

			//画右臂
			ctx.beginPath();
			ctx.moveTo(468 * rem / 100, 222 * rem / 100);
			ctx.lineTo(450 * rem / 100, 265 * rem / 100);
			ctx.lineTo(456 * rem / 100, 287 * rem / 100);
			ctx.lineTo(491 * rem / 100, 501 * rem / 100);
			ctx.lineTo(493 * rem / 100, 574 * rem / 100);
			ctx.lineTo(556 * rem / 100, 565 * rem / 100);
			ctx.lineTo(538 * rem / 100, 497 * rem / 100);
			ctx.lineTo(504 * rem / 100, 316 * rem / 100);
			ctx.lineTo(468 * rem / 100, 222 * rem / 100);
			

			//画腰部
			ctx.beginPath();
			ctx.moveTo(326 * rem / 100, 335 * rem / 100);
			ctx.lineTo(444 * rem / 100, 335 * rem / 100);
			ctx.lineTo(439 * rem / 100, 363 * rem / 100);
			ctx.lineTo(468 * rem / 100, 457 * rem / 100);
			ctx.lineTo(380 * rem / 100, 470 * rem / 100);
			ctx.lineTo(293 * rem / 100, 459 * rem / 100);
			ctx.lineTo(327 * rem / 100, 372 * rem / 100);
			ctx.lineTo(326 * rem / 100, 335 * rem / 100);
			

			//画臀部
			ctx.beginPath();
			ctx.moveTo(293 * rem / 100, 464 * rem / 100);
			ctx.lineTo(378 * rem / 100, 476 * rem / 100);
			ctx.lineTo(468 * rem / 100, 467 * rem / 100);
			ctx.lineTo(481 * rem / 100, 539 * rem / 100);
			ctx.lineTo(446 * rem / 100, 561 * rem / 100);
			ctx.lineTo(389 * rem / 100, 555 * rem / 100);
			ctx.lineTo(381 * rem / 100, 532 * rem / 100);
			ctx.lineTo(372 * rem / 100, 555 * rem / 100);
			ctx.lineTo(327 * rem / 100, 562 * rem / 100);
			ctx.lineTo(283 * rem / 100, 542 * rem / 100);
			ctx.lineTo(293 * rem / 100, 464 * rem / 100);
			

			//画大腿
			ctx.beginPath();
			ctx.moveTo(282 * rem / 100, 550 * rem / 100);
			ctx.lineTo(310 * rem / 100, 1009 * rem / 100);
			ctx.lineTo(453 * rem / 100, 1009 * rem / 100);
			ctx.lineTo(482 * rem / 100, 549 * rem / 100);
			ctx.lineTo(433 * rem / 100, 568 * rem / 100);
			ctx.lineTo(388 * rem / 100, 560 * rem / 100);
			ctx.lineTo(392 * rem / 100, 992 * rem / 100);
			ctx.lineTo(365 * rem / 100, 980 * rem / 100);
			ctx.lineTo(372 * rem / 100, 559 * rem / 100);
			ctx.lineTo(326 * rem / 100, 567 * rem / 100);
			ctx.lineTo(282 * rem / 100, 550 * rem / 100);
			

			//添加事件响应
			canvas.addEventListener('click', function (e) {
				p = index.getEventPosition(e);
				index.reDraw(p, ctx, index.option.girl_back, "girl_back");
			}, false);
		}
	}, reDraw: function (p, ctx, pos, type) {
		var className,
		descId,
		descId2,
		id,
		sympt_link,
		$Tab$target,
		$Tab = $("#symp_list_a"),
		_this = this;
		//	//保存序号的数组，这样，即使一次点多个，也能保存——本例中只能每次点一个
		//var whichObject = [];

		//绘图
		for (var temp in pos) {

			var item = pos[temp];
			ctx.beginPath();
			for (var i = 0; i < item.length; i++) {
				//console.info("x="+item[i].x+";y="+item[i].y);
				if (i == 0) {
					ctx.moveTo(item[i].x * rem / 100, item[i].y * rem / 100);
				} else {
					ctx.lineTo(item[i].x * rem / 100, item[i].y * rem / 100);

				}
			}
			//ctx.stroke();
			
			if (p && ctx.isPointInPath(p.x, p.y)) {

				//whichObject.push(temp);
				className = ".item_imgs_" + type;
				descId = "#" + type + "_" + temp;
				id = type + "_" + temp;
				$(className).hide();

				//如果属于器官部件,显示三次后跳转到器官大图
				var organ_pic = index.option.idToOrgan[id]
					if (organ_pic) {

						_this.blink($(descId), 2, function () {

							$("#pic").show();
							$(".organ").hide();
							$("#body_pic").hide();
							index.history=organ_pic;
							//alert(organ_pic);
							$("#" + organ_pic).show();

						});

						return

					}

					//2.一种为映射跳转到疾病列表,
				sympt_link = index.option.idTolink[id];
				$(descId).show();

				//如果跳转到症状列表,则执行.
				//str_select = ".left-wrap li a[link='" + sympt_link + "']";
				_this.blink($(descId), 2, function () {
					$("#symp_list_a").click();
					$(className).hide();
					index.scrollEvent(sympt_link)
				});

			}

		}

	},
	blink: function ($taget, Time, callFunction) {
		var _fn = arguments.callee;
		if (0 < Time) {
			$taget.show();
			setTimeout(function () {
				$taget.hide();
				setTimeout(function () {
					_fn($taget, --Time, callFunction);
				}, "180")
			}, "300")
		} else {
			callFunction && callFunction.call(this);
		}
	}
	
}

window.onload = function () {
	var wrapper = document.getElementById("right_wrapper");
	wrapper.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
	var wrapper = document.getElementById("left_wrapper");
	wrapper.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
	index.init();
}
