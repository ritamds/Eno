package fr.insee.eno;

import java.io.File;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.inject.Inject;

import fr.insee.eno.generation.Generator;
import fr.insee.eno.postprocessing.Postprocessor;
import fr.insee.eno.preprocessing.Preprocessor;
import fr.insee.eno.utils.FolderCleaner;

/**
 * Orchestrates the whole generation process.
 */
public class GenerationService {
	
	private static final Logger logger = LogManager.getLogger(GenerationService.class);
	
	private final Preprocessor preprocessor;
	private final Generator generator;
	private final Postprocessor postprocessor;

	@Inject
	public GenerationService(Preprocessor preprocessor, Generator generator, Postprocessor postprocessor) {
		this.preprocessor = preprocessor;
		this.generator = generator;
		this.postprocessor = postprocessor;
	}

	/**
	 * Launch every step needed in order to generate the target questionnaire.
	 * 
	 * @param inputFile The source file
	 * @param parametersFile Custom parameters file, could be null
	 * 
	 * @return The generated file
	 * @throws Exception
	 */
	// TODO finish implementation
	public File generateQuestionnaire(File inputFile, File parametersFile) throws Exception {
		logger.info("Generating questionnaire for: " + inputFile);
		cleanTempFolder();
		File preprocessResultFileName = this.preprocessor.process(inputFile, parametersFile);
		File generatedForm = this.generator.generate(preprocessResultFileName, "simpsons"); //FIXME get survey name dynamically
		File outputForm = this.postprocessor.process(generatedForm);
		logger.debug("Path to generated questionnaire: "+ outputForm.getAbsolutePath());
		return outputForm;
	}

	/**
	 * @throws Exception
	 */
	private void cleanTempFolder() throws Exception {
		FolderCleaner cleanService = new FolderCleaner();
		cleanService.cleanOneFolder(new File(Constants.TEMP_FOLDER_PATH));
	}

}
