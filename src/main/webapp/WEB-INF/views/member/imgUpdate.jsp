<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<form action="/member/updateImg" method="post" enctype="multipart/form-data">
    <h3>������ �̹��� ����</h3>
    <img src="${loginMember.userImage}" width="100"><br><br>
    <input type="file" name="profileImg" required><br><br>
    <input type="submit" value="�̹��� ����">
</form>
</body>
</html>