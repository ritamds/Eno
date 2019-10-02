package fr.insee.eno.postprocessing.pdf;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.insee.eno.Constants;
import fr.insee.eno.parameters.PostProcessing;
import fr.insee.eno.postprocessing.Postprocessor;
import fr.insee.eno.transform.xsl.XslTransformation;

public class PDFSpecificTreatmentPostprocessor implements Postprocessor {

	private static final Logger logger = LoggerFactory.getLogger(PDFSpecificTreatmentPostprocessor.class);

	private XslTransformation saxonService = new XslTransformation();

	@Override
	public File process(File input, byte[] parameters, String survey) throws Exception {
		return this.process(input, parameters, null, null, survey);
	}

	@Override
	public File process(File input, byte[] parametersFile, byte[] metadata, String survey) throws Exception {
		return this.process(input, parametersFile, metadata, null, survey);
	}
	
	@Override
	public File process(File input, byte[] parametersFile, byte[] metadata, byte[] specificTreatmentXsl, String survey) throws Exception {
		
		File outputForFOFile = new File(input.getParent(),
				Constants.BASE_NAME_FORM_FILE +
				Constants.SPECIFIC_TREAT_PDF_EXTENSION);
		logger.debug("Output folder for basic-form : " + outputForFOFile.getAbsolutePath());
		
		InputStream specificTreatmentXslIS = null;
		
		if(specificTreatmentXsl!=null) {
			specificTreatmentXslIS = new ByteArrayInputStream(specificTreatmentXsl);
			InputStream inputStream = FileUtils.openInputStream(input);
			OutputStream outputStream = FileUtils.openOutputStream(outputForFOFile);
			saxonService.transformWithPDFSpecificTreatment(inputStream, outputStream, specificTreatmentXslIS, parametersFile);
			
			inputStream.close();
			outputStream.close();
			specificTreatmentXslIS.close();
			
		}
		else {
			logger.info("Not specific treatment in params : simply copying this file" + input.getAbsolutePath());
			FileUtils.copyFile(input, outputForFOFile);
		}
		logger.info("End of specific treatment post-processing " + outputForFOFile.getAbsolutePath());
		
		return outputForFOFile;
	}
	
	public String toString() {
		return PostProcessing.PDF_SPECIFIC_TREATMENT.name();
	}

}
