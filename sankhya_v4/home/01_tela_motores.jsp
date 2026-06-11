<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
<head>
    <title>Controle de Motores</title>
    <snk:load/>
    <style>
        body { font-family: Arial, sans-serif; font-size: 12px; margin: 0; padding: 8px; }
        h3 { color: #1f3a5f; margin: 0 0 8px 0; }
        .painel { background: #f4f6f8; padding: 10px; margin-bottom: 10px; border: 1px solid #d0d7de; }
        table { width: 100%; border-collapse: collapse; margin-top: 6px; }
        th { background: #1f3a5f; color: #fff; padding: 5px; text-align: left; }
        td { padding: 5px; border-bottom: 1px solid #e0e0e0; }
        select, button { padding: 4px 8px; margin-right: 6px; }
        button { background: #1f3a5f; color: #fff; border: 0; cursor: pointer; padding: 5px 12px; }
        
        /* Classes de Status conforme a nova lista de opções */
        .LIGADO { color: #0a7a2a; font-weight: bold; }
        .ERRO { color: #c62828; font-weight: bold; }
        .DESLIGADO { color: #666; font-weight: bold; }
    </style>
</head>
<body>

<snk:query var="motores">
    
    SELECT ID, 
           NOME, 
           LADO, 
           STATUS AS STATUS_VAL,
           DECODE(STATUS, '1', 'LIGADO', '2', 'DESLIGADO', '3', 'ERRO', 'OUTRO') AS STATUS_TXT,
           TO_CHAR(DATA_HORA, 'DD/MM/YYYY HH24:MI') AS ULTIMA_VERIF
      FROM AD_ADMOTORES 
     ORDER BY LADO, NOME
</snk:query>


<!--<div class="painel">
    <h3>Registro de Status Motores</h3>
    <span class="info">Tabela: AD_ADMOTORES</span>
</div>
-->

<div class="painel">
    <h1>Tela: Checagem dos Motores</h1>
    <h3>Responsável pelo registro do status dos 9 motores do processo produtivo.</h3>
    <p>Instruções:</p>
    <ul>
        <li>Selecione o motor na lista</li>
        <li>Informe o status atual: LIGADO, DESLIGADO ou ERRO</li>
        <li>A data e hora do registro são gravadas automaticamente</li>
    </ul>
    <span class="info">Pequise no Sankhya: Status Motores</span>
</div>




<div class="painel">
    <h3>Status Atual dos Motores (AD_ADMOTORES)</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Nome do Motor</th>
            <th>Lado (EST/DIR)</th>
            <th>Status</th>
            <th>&Uacute;ltima Altera&ccedil;&atilde;o</th>
        </tr>
        <c:forEach items="${motores.rows}" var="h">
            <tr>
                <td><c:out value="${h.ID}"/></td>
                <td><c:out value="${h.NOME}"/></td>
                <td><c:out value="${h.LADO}"/></td>
                <td class="${h.STATUS_TXT}">
                    <c:out value="${h.STATUS_TXT}"/>
                </td>
                <td><c:out value="${h.ULTIMA_VERIF}"/></td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>