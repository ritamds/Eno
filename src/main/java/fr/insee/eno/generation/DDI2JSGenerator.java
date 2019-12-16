package fr.insee.eno.generation;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.insee.eno.Constants;
import fr.insee.eno.exception.EnoGenerationException;
import fr.insee.eno.transform.xsl.XslParameters;
import fr.insee.eno.transform.xsl.XslTransformation;

public class DDI2JSGenerator implements Generator {

	private static final Logger logger = LoggerFactory.getLogger(DDI2JSGenerator.class);

	private XslTransformation saxonService = new XslTransformation();

	@Override
	public File generate(File finalInput, byte[] parameters, String surveyName) throws Exception {
		logger.info("DDI2JS Target : START");
		logger.debug("Arguments : finalInput : " + finalInput + " surveyName " + surveyName);
		String formNameFolder = null;
		String outputBasicFormPath = null;

		formNameFolder = getFormNameFolder(finalInput);

		logger.debug("formNameFolder : " + formNameFolder);

		outputBasicFormPath = Constants.TEMP_FOLDER_PATH + "/" + surveyName + "/" + formNameFolder + "/form";
		logger.debug("Output folder for basic-form : " + outputBasicFormPath);

		String outputForm = outputBasicFormPath + "/form.xml";
		
		InputStream isTRANSFORMATIONS_DDI2JS_DDI2JS_XSL = Constants
				.getInputStreamFromPath(Constants.TRANSFORMATIONS_DDI2JS_DDI2JS_XSL);

		InputStream isFinalInput = FileUtils.openInputStream(finalInput);
		OutputStream osOutputFile = FileUtils.openOutputStream(new File(outputForm));
		
		try {
			saxonService.transformDDI2JS(isFinalInput, osOutputFile, isTRANSFORMATIONS_DDI2JS_DDI2JS_XSL, parameters);
		}catch(Exception e) {
			throw new EnoGenerationException("An error was occured during the "+in2out()+" transformation. "+e.getMessage());
		}
		
		isTRANSFORMATIONS_DDI2JS_DDI2JS_XSL.close();

		isFinalInput.close();
		osOutputFile.close();
		return new File(outputForm);
	}

	/**
	 * @param finalInput
	 * @return
	 */
	public String getFormNameFolder(File finalInput) {
		String formNameFolder;
		formNameFolder = FilenameUtils.getBaseName(finalInput.getAbsolutePath());
		formNameFolder = FilenameUtils.removeExtension(formNameFolder);
		formNameFolder = formNameFolder.replace(XslParameters.TITLED_EXTENSION, "");
		return formNameFolder;
	}

	public String in2out() {
		return "ddi2js";
	}
}
