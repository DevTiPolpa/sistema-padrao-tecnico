<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
<head>
    <title>Configura&ccedil;&atilde;o de Par&acirc;metros</title>
    <snk:load/>
    <style>
        body { font-family: Arial, sans-serif; font-size: 12px; margin: 0; padding: 8px; }
        h3 { color: #1f3a5f; margin: 0 0 8px 0; }
        .painel { background: #f4f6f8; padding: 10px; margin-bottom: 10px; border: 1px solid #d0d7de; }
        table { width: 100%; border-collapse: collapse; margin-top: 6px; }
        th { background: #1f3a5f; color: #fff; padding: 5px; text-align: left; }
        td { padding: 5px; border-bottom: 1px solid #e0e0e0; }
        input, button { padding: 4px 8px; margin-right: 6px; }
        button { background: #1f3a5f; color: #fff; border: 0; cursor: pointer; padding: 5px 12px; }
        .row { margin-bottom: 6px; }
        label { display: inline-block; width: 90px; }
    </style>
</head>
<body>

<snk:query var="parametros">
     SELECT ID, 
           NOME, 
           DESCRICAO, 
           TIPO,
           TO_CHAR(DATA_CRIACAO,'DD/MM/YYYY HH24:MI') AS CRIACAO
      FROM AD_ADPARAMETROSQ
     ORDER BY NOME
</snk:query>


<div class="painel">
    <h3>Parametros cadastrados</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Descri&ccedil;&atilde;o</th>
            <th>Tipo</th>
            <th>Data Cria&ccedil;&atilde;o</th>
        </tr>
        <c:forEach items="${parametros.rows}" var="p">
            <tr>
                <td><c:out value="${p.ID}"/></td>
                <td><c:out value="${p.NOME}"/></td>
                <td><c:out value="${p.DESCRICAO}"/></td>
                <td><c:out value="${p.TIPO}"/></td>
                <td><c:out value="${p.CRIACAO}"/></td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>
