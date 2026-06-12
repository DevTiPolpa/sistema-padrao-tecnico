<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
<head>
    <title>Umidade do Produto</title>
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
    </style>
</head>
<body>

<snk:query var="registros">
    SELECT TO_CHAR(DATA_HORA,'DD/MM/YYYY HH24:MI') AS DATA_HORA_FORMAT,
           CARRINHO,
           NUMERO_PALETE,
           VALOR_UMIDADE,
           DECODE(STATUS, '1', 'NORMAL', '2', 'ABAIXO', '3', 'ACIMA', 'OUTRO') AS STATUS_TXT
      FROM AD_ADUMIDADEPRODUTO
     WHERE ROWNUM <= 100
     ORDER BY DATA_HORA DESC
</snk:query>

<div class="painel">
    <h1>Tela: Umidade do Produto</h1>
    <h3>Responsável pelo controle da umidade do produto por palete.</h3>
    <p>Dados obrigatórios:</p>
    <ul>
        <li>Número do palete</li>
        <li>Valor da umidade medida</li>
        <li>A data e hora são gravadas automaticamente</li>
    </ul>

    <p>Faixa ideal de umidade:</p>
    <ul>
        <li>Mínimo: 18% | Máximo: 22%</li>
        <li>Fora dessa faixa o registro é marcado como fora do padrão</li>
    </ul>
    <span class="info">Pequise no Sankhya: Umidade do Produto</span>
</div>

<div class="painel">
    <h3>&Uacute;ltimos registros</h3>
    <table>
        <tr>
            <th>Data/Hora</th>
            <th>Carrinho</th>
            <th>Palete</th>
            <th>Umidade em %</th>
            <th>Status</th>
        </tr>
        <c:forEach items="${registros.rows}" var="r">
            <tr>
                <td><c:out value="${r.DATA_HORA_FORMAT}"/></td>
                <td><c:out value="${r.CARRINHO}"/></td>
                <td><c:out value="${r.NUMERO_PALETE}"/></td>
                <td><c:out value="${r.VALOR_UMIDADE}"/>%</td>
                <td class="${r.STATUS_TXT}"><c:out value="${r.STATUS_TXT}"/></td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>
