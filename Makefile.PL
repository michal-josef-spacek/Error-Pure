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
);
