# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Error::Pure',
	'PREREQ_PM' => {
		'Exporter' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/Error::Pure/*.t '.
			't/Error::Pure::AllError/*.t '.
			't/Error::Pure::Clean/*.t '.
			't/Error::Pure::Error/*.t '.
			't/Error::Pure::ErrorList/*.t '.
			't/Error::Pure::Multiple/*.t '.
			't/Error::Pure::Output::Text/*.t '.
			't/Error::Pure::Print/*.t',
	},
);
