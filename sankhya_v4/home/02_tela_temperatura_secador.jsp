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
        .NORMAL { color: #0a7a2a; font-weight: bold; }
        .ABAIXO { color: #1565c0; font-weight: bold; }
        .ACIMA  { color: #c62828; font-weight: bold; }
        .info { color: #1f3a5f; font-weight: bold; margin-bottom: 8px; display: block; }
        .NAO_INFORMADO {color: #ff9800; font-weight: bold;}
    </style>
</head>
<body>

<snk:query var="registros">
    SELECT
    TO_CHAR(TO_DATE(DATA_HORA, 'DD/MM/RR HH24:MI'), 'DD/MM/YYYY HH24:MI') AS DATA_HORA_FMT,
    TEMPERATURA,
    CASE
        WHEN ZONA = '1' THEN 'ZONA 1'
        WHEN ZONA = '2' THEN 'ZONA 2'
        WHEN ZONA = '3' THEN 'ZONA 3'
        WHEN ZONA = '4' THEN 'ZONA 4'
        WHEN ZONA = '5' THEN 'ZONA 5'
        WHEN ZONA = '6' THEN 'ZONA 6'
        WHEN ZONA = '7' THEN 'ZONA 7'
        WHEN ZONA = '8' THEN 'ZONA 8'
        ELSE 'ZONA DO SECADOR NÃO INFORMADA'
    END AS ZONA,
    CASE
        WHEN STATUS = '1' THEN 'NORMAL'
        WHEN STATUS = '2' THEN 'ABAIXO'
        WHEN STATUS = '3' THEN 'ACIMA'
        ELSE 'NAO_INFORMADO'
    END AS STATUS_TEXT
FROM AD_ADTEMPERATURASECADOR
ORDER BY TO_DATE(DATA_HORA, 'DD/MM/RR HH24:MI') DESC
FETCH FIRST 100 ROWS ONLY
</snk:query>

<div class="painel">
    <h1>Tela: Temperatura do Secador</h1>
    <h3>Responsável pelo registro da temperatura dos secadores ao longo do processo produtivo.</h3>
    <p>Regras:</p>
    <ul>
        <li>Registro obrigatório a cada 2 horas (intervalo configurável nos Parâmetros)</li>        
    </ul>
    <p>Faixa ideal de temperatura:</p>
    <ul>
        <li>Mínimo: 50°C | Máximo: 110°C</li>
        <li>Abaixo de 50°C → fora do padrão (status: ABAIXO)</li>
        <li>Acima de 110°C → fora do padrão (status: ACIMA)</li>
    </ul>
    <span class="info">Pequise no Sankhya: Temperatura no Secador</span>
</div>

<div class="painel">
    <h3>&Uacute;ltimos registros</h3>
    <table>
        <tr>
            <th>Data/Hora</th>
            <th>Temperatura (&#176;C)</th>
            <th>Zona Secador</th>
            <th>Status</th>
        </tr>
        <c:forEach items="${registros.rows}" var="r">
            <tr>
                <td><c:out value="${r.DATA_HORA_FMT}"/></td>
                <td><c:out value="${r.TEMPERATURA}"/>&#176;C</td>
                <!--<td class="${r.STATUS}"><c:out value="${r.STATUS}"/></td> -->
                <!--<td><c:out value="${h.NOME}"/></td>-->
                <!--<td><c:out value="${r.STATUS_TXT}"/></td>-->
                <td><c:out value="${r.ZONA}"/></td>
                <td class="${r.STATUS_TEXT}">
                    <c:out value="${r.STATUS_TEXT}"/>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>
