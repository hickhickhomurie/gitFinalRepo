<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>업체 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="/resources/css/common.css" />
</head>
<body class="bg-gray-50 text-gray-800">

<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<div class="max-w-7xl mx-auto px-4 py-8">
    <div class="text-3xl font-bold mb-6">업체 목록</div>

    <form action="/updateCafe" method="post">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-300 border border-gray-300 rounded-lg overflow-hidden shadow-sm">
                <thead class="bg-gray-100">
					<tr>
                        <th class="px-4 py-2 text-left">업체명</th>
                        <th class="px-4 py-2 text-left">호스트ID</th>
                        <th class="px-4 py-2 text-left">주소</th>
                        <th class="px-4 py-2 text-left">상태</th>
                        <th class="px-4 py-2 text-left">상태변경</th>                        
                        <th class="px-4 py-2 text-center">신청정보</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <c:forEach var="cafe" items="${cafeList}">
                    <c:if test="${!(cafe.cafeRejectReason == 'N' and cafe.cafeApplyStatus != null)}">
                        <tr class="hover:bg-gray-300">
                            <td class="px-4 py-2">${cafe.cafeName}</td>
                            <td class="px-4 py-2">${cafe.hostId}</td>
                            <td class="px-4 py-2">${cafe.cafeAddr}</td>
                            <td class="px-4 py-2">${cafe.cafeManageStatus}</td>
                            <td class="px-4 py-2">
								 <!-- 상태 변경 select 박스 -->
								<select id="statusSelect_${cafe.cafeNo}" name="${cafe.cafeNo}" onchange="handleStatusChange('${cafe.cafeNo}')">
								    <option value="0">상태변경</option>
								    <c:choose>
								        <c:when test="${cafe.cafeManageStatus == '수정대기'}">
								            <option value="1">승인</option>
								            <option value="3">반려</option>
								        </c:when>
								        <c:when test="${cafe.cafeManageStatus == '등록대기'}">
								            <option value="2">승인</option>
								            <option value="3">반려</option>
								        </c:when>
								        <c:when test="${cafe.cafeManageStatus == '승인'}">
								            <option value="4">삭제</option>
								        </c:when>
								    </c:choose>
								</select>
								
								<!-- 반려 사유 select 박스, 숨김 상태 -->
								<select id="rejectReason_${cafe.cafeNo}" class="rejectReason mt-2 border border-gray-300 rounded px-2 py-1 w-full" style="display:none;"
								    onchange="handleRejectReasonChange('${cafe.cafeNo}')">
								    <option value="">반려 사유 선택</option>
								    <c:forEach var="code" items="${codeList}">
								        <option value="3_${code.codeId}">${code.codeName}</option>
								    </c:forEach>
								</select>
                            </td>
                            <td class="px-4 py-2 text-center">
                                <c:choose>
                                    <c:when test="${cafe.cafeManageStatus == '수정대기' || cafe.cafeManageStatus == '등록대기'}">	<%-- cafeManageStatus => 카페에 대한 상태 => 그 값이 수정대기 && 등록대기일 경우에만 보여줌--%>
                                        <button type="button" onclick="requestInfo('${cafe.cafeNo}')" class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 transition">
                                            신청정보 열람
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <input type="hidden" name="selectedStatusJson" id="selectedStatusJson">

        <div class="mt-6 text-right">
            <button type="submit" onclick="return submitCafeForm();" class="bg-blue-600 text-white px-5 py-2 rounded hover:bg-blue-400 transition">
                저장
            </button>
        </div>
    </form>

    <!-- 페이지네이션 -->
    <div id="pageNavi" class="mt-8 text-center">
        ${pageNavi}
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>

<script>
function handleStatusChange(cafeNo) {

    // 1. 함수 호출 시 cafeNo 값과 타입 확인
    console.log("handleStatusChange 함수 호출됨");
    console.log("전달된 cafeNo:", cafeNo, typeof cafeNo);

    // *** 이 줄을 꼭 추가해주세요! ***
    const statusSelectId = 'statusSelect_'+cafeNo;
    console.log("찾으려는 statusSelect ID:", statusSelectId);

    // 3. getElementById 실행 결과 확인
    const statusSelect = document.getElementById(statusSelectId);
    console.log("document.getElementById(statusSelectId) 결과:", statusSelect); // 이제 이 값이 null인지 확인 가능합니다.

    // 4. 반려 사유 select 박스 찾으려는 ID 및 결과 확인
    const rejectReasonId = 'rejectReason_'+cafeNo;
    console.log("찾으려는 rejectReason ID:", rejectReasonId);
    const reasonSelect = document.getElementById(rejectReasonId);
    console.log("document.getElementById(rejectReasonId) 결과:", reasonSelect);


    if (!statusSelect) {
        console.warn(`오류: ID "${statusSelectId}"인 요소를 찾을 수 없습니다.`);
        return; // 요소를 찾지 못했으므로 더 진행하지 않습니다.
    }

    console.log("statusSelect 요소 찾음:", statusSelect);
    console.log("statusSelect 현재 선택된 값:", statusSelect.value); // 3

    // 반려 사유 select 박스 숨김/표시 로직
    if (reasonSelect) { // reasonSelect 요소가 존재하는지 먼저 확인
        if (statusSelect.value === "3") {
            reasonSelect.style.display = ""; // 또는 'block'
        } else {
            reasonSelect.style.display = "none";
            reasonSelect.value = ""; // 다른 상태 선택 시 반려 사유 값 초기화
        }
    } else {
        console.warn(`경고: ID "${rejectReasonId}"인 반려 사유 요소를 찾을 수 없습니다.`);
        if (statusSelect.value === "3") {
             alert("반려 사유를 선택할 수 있는 요소가 없습니다.");
             statusSelect.value = "0"; // 상태를 다시 초기 상태로 되돌림
        }
    }
}
    



function handleRejectReasonChange(cafeNo) {
    const statusSelect = document.getElementById('statusSelect_' + cafeNo);
    const reasonSelect = document.getElementById('rejectReason_' + cafeNo);

    if (statusSelect && reasonSelect) {
        if (reasonSelect.value) {
            console.log("반려 사유 선택됨: " + reasonSelect.value);
            //statusSelect.value = reasonSelect.value; // 상태를 반려 사유로 업데이트
        } else {
            console.log("반려 사유 선택 안 됨, 상태 복원");
            statusSelect.value = "3"; // 기본 반려 값 설정
        }
    }
}



function submitCafeForm() {
    const statusMap = {};
    let isValid = true;

    document.querySelectorAll("select[id^='statusSelect_']").forEach(statusSelect => {
        const cafeNo = statusSelect.id.replace('statusSelect_', '');
        let statusValue = statusSelect.value;
        const reasonSelect = document.getElementById('rejectReason_' + cafeNo);

        if (statusValue === "3") {
            // 반려인데 사유를 선택하지 않음
            if (!reasonSelect || reasonSelect.value === "") {
                alert("반려 사유를 선택해주세요.");
                reasonSelect?.focus();
                isValid = false;
                return; // 해당 항목에서 중단하고 다음으로 넘어가지 않음
            }
            statusValue = reasonSelect.value; // 반려 사유 반영
        }

        if (statusValue !== "0" && statusValue !== "") {
            statusMap[cafeNo] = statusValue;
        }
    });

    if (!isValid) {
        return false; // 유효성 검사 실패 시 form 제출 중단
    }

    const jsonStr = JSON.stringify(statusMap);
    document.getElementById("selectedStatusJson").value = jsonStr;
    return true; // 유효성 통과 시 form 제출
}





function requestInfo(cafeNo) {		//cafeNo는 파라미터 
    const url = "/admin/cafeRequestDetail?cafeNo=" + cafeNo;
    window.open(url, "신청정보", "width=600,height=500,left=100,top=100");
}


</script>

</body>
</html>