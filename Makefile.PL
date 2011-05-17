# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'Error::Pure',
	'PREREQ_PM' => {
		'Cwd' => 0,
		'English' => 0,
		'Exporter' => 0,
		'List::MoreUtils' => 0,
		'Readonly' => 0,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/Error::Pure/*.t '.
			't/Error::Pure::AllError/*.t '.
			't/Error::Pure::Clean/*.t '.
			't/Error::Pure::Die/*.t '.
			't/Error::Pure::Error/*.t '.
			't/Error::Pure::ErrorList/*.t '.
			't/Error::Pure::Output::Text/*.t '.
			't/Error::Pure::Print/*.t '.
			't/Error::Pure::Utils/*.t',
	},
);
