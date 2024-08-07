const { Router } = require("express");
const router = Router();

const {
  crear_proyecto,
  crear_categoria,
  proyectos_areas,
  all_categorias,
  roles_proyecto,
  subir_pdf,
  documentos_proyectos,
  ver_pdf,
  list_categorias,
  editar_categoria,
  estado_categoria,
  guias_proyectos,
  subir_guia,
  download_guia,
  ver_flujo_proyecto,
  borradores_proyecto,
  proyect_data,
  niveles_estado,
  ver_flujo_proyecto_nivel2,
  subir_primer_nivel,
  id_doc,
  subir_level,
  publicar_doc,
  deshabilitar_flujo,
  rechazar_proyecto,
  historial_proyecto,
  ver_flujo_rechazado,
  ver_flujo_historial,
  ver_documentos_extras,
  ver_pdf_url,
  subir_pdf_extra,
  combinar_pdfs,
  ver_pdf_2,
  participantes_actuales_proyecto,
  participantes_sin_proyectos,
  agregar_usuario_proyecto,
  expulsar_usuario_proyecto,
  generar_caratula,
  generar_lista_usuarios,
  ver_documentos_contraportadas,
  subir_contraportada,
  Convertir_Editor_a_pdf,
  proyectos_publicados_para_reformas,
  iniciar_reforma,
  ver_proyectos_publicados_versiones,
  ver_pdf_url_version,
  firmar_documento_p12,
  ver_docs_alcance,
  ver_pdf_alcance,
  editar_proyecto,
  datos_a_editar_proyecto,
  guardar_pdf_editor,
  datos_revision_proyecto,
  documentos_por_firmar,
  enviar_pdf_cliente,
  calcular_coordenadas_firma,
  firmas_proyectos,
  cambiar_estado_firma,
  verificador_firmas,
  subir_documento_firmado,
  list_sub_categorias,
  crear_sub_categoria,
  estado_SUB_categoria,
  ver_flujo_categoria,
  flujos_categorias,
  ver_word,
  download_doc_proyecto,
  listar_recursos_compartidos,
  crear_recurso_compartido,
  eliminar_recurso_compartido,
} = require("../controllers/Proyects/proyects-controller");

const { upload } = require("../middleware/multer_pdf");
const { upload_guia } = require("../middleware/multer_guias");
const { upload_alcances } = require("../middleware/multer_alcances");
const { upload_editor } = require("../middleware/multer_editor_texto");

//tengo que crear un trigger que inserte el codigo del proyecto
router.post("/crear_proyecto", crear_proyecto);
router.post("/crear_categoria", crear_categoria);
router.post("/crear_sub_categoria", crear_sub_categoria);

router.post("/editar_categoria", editar_categoria);
router.post("/estado/:id", estado_categoria);
router.post("/estado_sub/:id", estado_SUB_categoria);

router.get("/proyectos_areas/:id/:id2/:id3", proyectos_areas);
router.get("/categorias_proyecto", all_categorias);
router.post("/roles_proyecto", roles_proyecto);
router.get("/list_categorias", list_categorias);
router.get("/list_sub_categorias", list_sub_categorias);
router.get("/recursos/:id", listar_recursos_compartidos);
router.post("/agregar_recurso/", crear_recurso_compartido);
router.post("/eliminar_recurso/", eliminar_recurso_compartido);

router.post("/subir_pdf", upload.single("file"), subir_pdf);
router.get("/documentos_proyectos/:id", documentos_proyectos);
router.get("/pdf/:id", ver_pdf);
router.get("/word/:id", ver_word);
router.get("/guias/:id", guias_proyectos);
router.post("/upload_guia", upload_guia.single("file"), subir_guia);
router.post("/ver_guia", download_guia);
router.post("/descargardoc", download_doc_proyecto);
router.get("/ver_flujo_proyecto/:id", ver_flujo_proyecto);
router.get("/borradores/:id", borradores_proyecto);
router.get("/data_pro/:id", proyect_data);
router.get("/estados_niveles/:id", niveles_estado);
router.get("/ver_niveles_actual/:id", ver_flujo_proyecto_nivel2);
router.post("/subir_nivel", subir_primer_nivel);
router.get("/UltimoPDF/:id", id_doc);
router.post("/SubirLevel/:id", subir_level);
router.post("/Publicar/:id", publicar_doc);
router.post("/EliminarFLujo/:id", deshabilitar_flujo);
router.post("/Rechazar/:id", rechazar_proyecto);
router.get("/Historial/:id", historial_proyecto);
router.get("/FlujoRechazado/:id", ver_flujo_rechazado);
router.get("/VerFlujoHistorial/:id", ver_flujo_historial);
router.get("/VerFlujoCategoria/:id", ver_flujo_categoria);

//
router.get("/DocumentosExtras/:id", ver_documentos_extras);
router.get("/DocumentosExtras_portadas/:id", ver_documentos_contraportadas);
router.get("/VerpdfUrl/:id", ver_pdf_url);
router.post("/subir_pdf_extra", upload.single("file"), subir_pdf_extra);
router.post("/Combinar_pdfs/:id", combinar_pdfs);
router.get("/pdf2/:id", ver_pdf_2);
router.get("/participantes_proyecto/:id/:id2", participantes_actuales_proyecto);
router.get("/participantes_sin_proyecto/:id/:id2", participantes_sin_proyectos);
router.post("/agregar_usuario_proyecto", agregar_usuario_proyecto);
router.post("/expulsar_usuario_proyecto", expulsar_usuario_proyecto);
router.post("/generar_caratula/:id", generar_caratula);
router.post("/generar_listado_participantes/:id", generar_lista_usuarios);
router.post("/subir_contraportada", upload.single("file"), subir_contraportada);
router.post("/Convertir_pdf", Convertir_Editor_a_pdf);
//subir_contraportada
//Convertir_Editor_a_pdf
router.get("/proyectos_publicados", proyectos_publicados_para_reformas);
router.post(
  "/reformar_proyecto",
  upload_alcances.single("file"),
  iniciar_reforma
);
//subir_contraportada

//firmar documento pdf para pruebas
router.post("/FirmarPDF", firmar_documento_p12);

//Ver Proyectos Publicados versiones
router.get("/LisComboBox/:idproyecto", ver_proyectos_publicados_versiones);
router.get("/VerPdfUrlVersiones/:id", ver_pdf_url_version);

//Ver el alcace en la reforma
router.get("/Ver_Alcance/:id", ver_docs_alcance);
router.get("/Pdf_alcance/:id", ver_pdf_alcance);
router.post("/EditarDatos/:id", editar_proyecto);
router.get("/DatosEditar/:id", datos_a_editar_proyecto);

//Para guardar el pdf generado en el editor de texto en la APi
router.post(
  "/guardar_pdf_editor",
  upload_editor.single("file"),
  guardar_pdf_editor
);
router.get("/datos_revision/:id/:id2", datos_revision_proyecto);

router.get("/DocumentosporFirmar/:id", documentos_por_firmar);
router.post("/PDF_para_firmar/:id", enviar_pdf_cliente);
//calcular las coordenadas para poder fimar el documento de manera automatica
router.get("/Calcularcoordenadas/:id/:id2", calcular_coordenadas_firma);
router.get("/UsuariosFirmas/:id", firmas_proyectos);
router.post("/Editar_estado_firma", cambiar_estado_firma);
router.get("/Verificarfirmas/:id", verificador_firmas);
router.post(
  "/DocumentoFirmado",
  upload.single("file"),
  subir_documento_firmado
);

//ver los flujos que tiene una categoria
router.get("/FlujosCategoria/:id", flujos_categorias);

module.exports = router;
