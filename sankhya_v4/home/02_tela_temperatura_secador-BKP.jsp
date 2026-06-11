<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
<head>
    <title>Temperatura do Secador</title>
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
        
        /* Classes de Status baseadas no DECODE */
        .NORMAL { color: #0a7a2a; font-weight: bold; }
        .ABAIXO { color: #1565c0; font-weight: bold; }
        .ACIMA { color: #c62828; font-weight: bold; }
        
        .info { color: #1f3a5f; font-weight: bold; margin-bottom: 8px; display: block; }
    </style>
</head>
<body>

<!--    
<snk:query var="params">
    SELECT NOME, VALOR FROM PARAMETROS
     WHERE NOME IN ('TEMP_SECADOR_MIN','TEMP_SECADOR_MAX','INTERVALO_MEDICAO_HORAS')
</snk:query>

<c:forEach items="${params.rows}" var="p">
    <c:if test="${p.NOME eq 'TEMP_SECADOR_MIN'}"><c:set var="tMin" value="${p.VALOR}"/></c:if>
    <c:if test="${p.NOME eq 'TEMP_SECADOR_MAX'}"><c:set var="tMax" value="${p.VALOR}"/></c:if>
    <c:if test="${p.NOME eq 'INTERVALO_MEDICAO_HORAS'}"><c:set var="intervalo" value="${p.VALOR}"/></c:if>
</c:forEach>
-->

<snk:query var="registros">
    SELECT TO_CHAR(DATA_HORA,'DD/MM/YYYY HH24:MI') AS DATA_HORA_FMT,
           TEMPERATURA, 
           DECODE(STATUS, '1', 'NORMAL', '2', 'ABAIXO', '3', 'ACIMA', '?') AS STATUS_TXT
      FROM AD_ADTEMPERATURASECADOR
     ORDER BY DATA_HORA DESC
     FETCH FIRST 100 ROWS ONLY
</snk:query>


<div class="painel">
    <h3>Registro de Status Motores</h3>
    <span class="info">Tabela: AD_ADMOTORES</span>
</div>


<div class="painel">
    <h3>Registro de temperatura do secador (AD_ADTEMPERATURASECADOR)</h3>
    <span class="info">
        Faixa ideal: <c:out value="${tMin}"/>&#176;C a <c:out value="${tMax}"/>&#176;C
        &nbsp;|&nbsp; Intervalo: <c:out value="${intervalo}"/>h
    </span>
    <form method="post" action="sankhya_fix/02_tela_temperatura_secador_salvar.jsp">
        <label>Temperatura (&#176;C):</label>
        <input type="number" name="temperatura" step="0.01" style="width:120px;" required/>
        <button type="submit">Registrar</button>
    </form>
</div>


<div class="painel">
    <h3>&Uacute;ltimos registros</h3>
    <table>
        <tr>
            <th>Data/Hora</th>
            <th>Temperatura</th>
            <th>Status</th>
        </tr>
        <c:forEach items="${registros.rows}" var="r">
            <tr>
                <td><c:out value="${r.DATA_HORA_FMT}"/></td>
                <td><c:out value="${r.TEMPERATURA}"/> &#176;C</td>
                <td class="${r.STATUS_TXT}"><c:out value="${r.STATUS_TXT}"/></td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>