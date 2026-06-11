<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
<head>
    <title>Carrinhos no Secador</title>
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
        
        /* Cores dos Status */
        .EM_SECAGEM { color: #1565c0; font-weight: bold; } 
        .CONCLUIDO { color: #0a7a2a; font-weight: bold; }  
        .ATRASADO { color: #c62828; font-weight: bold; }   
    </style>
</head>
<body>

<snk:query var="movimentacoes">
    /* Corrigido: O nome da coluna no seu print é CARRINHO e não NUMERO_CARRINHO */
    SELECT 
        ID,
        CARRINHO,
        BANDEJAS,
        PESO,
        TO_CHAR(DATA_ENTRADA,'DD/MM/YYYY HH24:MI') AS ENTRADA,
        TO_CHAR(DATA_SAIDA,'DD/MM/YYYY HH24:MI') AS SAIDA,
        /* Cálculo do Tempo decorrido em horas */
        ROUND((NVL(DATA_SAIDA, SYSDATE) - DATA_ENTRADA) * 24, 2) AS TEMPO_DECORRIDO,
        /* Lógica de Status Automático */
        CASE 
            WHEN DATA_SAIDA IS NOT NULL THEN 'CONCLUIDO'
            WHEN (SYSDATE - DATA_ENTRADA) * 24 > 18 THEN 'ATRASADO'
            ELSE 'EM_SECAGEM'
        END AS STATUS_DINAMICO
    FROM AD_ADCARRINHOS
    ORDER BY DATA_ENTRADA DESC
    FETCH FIRST 100 ROWS ONLY
</snk:query>

<div class="painel">
    <h1>Tela: Carrinhos no Secador</h1>
    <h3>Responsável pelo controle de entrada e saída dos carrinhos no processo de secagem.</h3>

    <p>Dados registrados na entrada:</p>
    <ul>
        <li>Número do carrinho (existente ou novo)</li>
        <li>Quantidade de bandejas</li>
        <li>Peso em KG</li>
        <li>Data e hora de entrada (automática)</li>
    </ul>

    <p>Dados registrados na saída:</p>
    <ul>
        <li>Data e hora de saída</li>
        <li>Tempo total de permanência (calculado automaticamente)</li>
    </ul>

    <p>Regras:</p>
    <ul>
        <li>Tempo padrão de secagem: 18 horas</li>
        <li>Carrinhos que ultrapassarem o tempo padrão são marcados como ATRASADO</li>
        <li>Carrinhos dentro do prazo são marcados como CONCLUÍDO</li>
    </ul>

    <span class="info">Pequise no Sankhya: Carrinhos Secador</span>
</div>


<div class="painel">
    <h3>Movimenta&ccedil;&atilde;o atual</h3>
    <table>
        <tr>
            <th>Carrinho</th>
            <th>Entrada</th>
            <th>Sa&iacute;da</th>
            <th>Bandejas</th>
            <th>Peso (KG)</th>
            <th>Tempo (h)</th>
            <th>Status</th>
        </tr>
        <c:forEach items="${movimentacoes.rows}" var="m">
            <tr>
                <td><c:out value="${m.CARRINHO}"/></td>
                <td><c:out value="${m.ENTRADA}"/></td>
                <td><c:out value="${not empty m.SAIDA ? m.SAIDA : '-'}"/></td>
                <td><c:out value="${m.BANDEJAS}"/></td>
                <td><c:out value="${m.PESO}"/></td>
                <td><c:out value="${m.TEMPO_DECORRIDO}"/>h</td>
                <td class="${m.STATUS_DINAMICO}">
                    <c:choose>
                        <c:when test="${m.STATUS_DINAMICO eq 'EM_SECAGEM'}">EM SECAGEM</c:when>
                        <c:otherwise><c:out value="${m.STATUS_DINAMICO}"/></c:otherwise>
                    </c:choose>
                </td>
                
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>