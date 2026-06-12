<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
<head>
    <title>Padr&atilde;o T&eacute;cnico</title>
    <snk:load/>
    <style>
        body { font-family: Arial, sans-serif; font-size: 13px; background: #f0f2f5; margin: 0; padding: 10px; }
        h2 { color: #1f3a5f; margin-bottom: 16px; }
        .grid { display: flex; flex-wrap: wrap; gap: 12px; }
        .card { background: #fff; border: 1px solid #d0d7de; border-radius: 6px; padding: 18px 22px; width: 190px; cursor: pointer; }
        .card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-color: #1f3a5f; }
        .card h3 { margin: 0 0 6px 0; color: #1f3a5f; font-size: 14px; }
        .card p { margin: 0; color: #666; font-size: 11px; }
        .icone { font-size: 26px; margin-bottom: 8px; }
    </style>
    <script type="text/javascript">
        function irParaTela(nivelId) {
            openLevel(nivelId, {});
        }
    </script>
</head>
<body>
    <h2>Padr&atilde;o T&eacute;cnico &mdash; Controle de Qualidade</h2>
    <div class="grid">
        <div class="card" onclick="irParaTela('02R')">
            <div class="icone">&#9881;</div>
            <h3>Status Motores</h3>
            <p>Checagem dos 9 motores</p>
        </div>
        <div class="card" onclick="irParaTela('03R')">
            <div class="icone">&#127777;</div>
            <h3>Temperatura no Secador</h3>
            <p>Registro a cada 2 horas</p>
        </div>
        <div class="card" onclick="irParaTela('04R')">
            <div class="icone">&#128167;</div>
            <h3>Umidade do Produto</h3>
            <p>Controle por palete</p>
        </div>
        <div class="card" onclick="irParaTela('05R')">
            <div class="icone">&#128667;</div>
            <h3>Carrinhos no Secador</h3>
            <p>Entrada e sa&iacute;da</p>
        </div>
        <div class="card" onclick="irParaTela('06R')">
            <div class="icone">&#128293;</div>
            <h3>Umidade da Estufa</h3>
            <p>Controle da estufa</p>
        </div>
        <!--<div class="card" onclick="irParaTela('07R')">
            <div class="icone">&#9881;</div>
            <h3>Par&acirc;metros</h3>
            <p>Configura&ccedil;&atilde;o do sistema</p>
        </div> -->
    </div>
</body>
</html>
