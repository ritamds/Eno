package fr.insee.eno.postprocessing.fr;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.insee.eno.Constants;
import fr.insee.eno.exception.EnoGenerationException;
import fr.insee.eno.parameters.PostProcessing;
import fr.insee.eno.postprocessing.Postprocessor;
import fr.insee.eno.transform.xsl.XslTransformation;

public class FRModeleColtranePostprocessor implements Postprocessor {

	private static final Logger logger = LoggerFactory.getLogger(FRModeleColtranePostprocessor.class);

	private XslTransformation saxonService = new XslTransformation();

	@Override
	public File process(File input, byte[] parameters, String survey) throws Exception {


		File outputForFRFile = new File(input.getParent(),
				Constants.BASE_NAME_FORM_FILE +
				Constants.MODELE_COLTRANE_FR_EXTENSION);

		logger.debug("Output folder for basic-form : " + outputForFRFile.getAbsolutePath());

		String sUB_TEMP_FOLDER = Constants.tEMP_DDI_FOLDER(Constants.sUB_TEMP_FOLDER(survey));
		File mappingFile = Constants.tEMP_MAPPING_TMP(sUB_TEMP_FOLDER);

		InputStream FO_XSL = Constants.getInputStreamFromPath(Constants.UTIL_FR_MODELE_COLTRANE_XSL);

		InputStream inputStream = FileUtils.openInputStream(input);
		OutputStream outputStream = FileUtils.openOutputStream(outputForFRFile);
		InputStream mappingStream=null;
		if(mappingFile.exists()) {
			logger.info("Loading mapping.xml file : "+mappingFile.getAbsolutePath());
			mappingStream = FileUtils.openInputStream(mappingFile);
		}

		try {
			saxonService.transformModelColtraneFr(inputStream, outputStream, FO_XSL, mappingStream);
		}catch(Exception e) {
			throw new EnoGenerationException("An error was occured during the " + toString() + " transformation. "+e.getMessage());
		}

		inputStream.close();
		outputStream.close();
		FO_XSL.close();
		mappingStream.close();
		logger.info("End of ModeleColtrane post-processing " + outputForFRFile.getAbsolutePath());

		return outputForFRFile;
	}

	@Override
	public String toString() {
		return PostProcessing.FR_MODELE_COLTRANE.name();
	}

}
