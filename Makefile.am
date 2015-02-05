ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS}

dist_bin_SCRIPTS = 

if HAVE_CHEM
dist_bin_SCRIPTS += src/chem/element2mass.py src/chem/mass2element.py src/chem/reaxspecies.sh src/chem/temp2vel.py
endif

if HAVE_INTERACTIVE
dist_bin_SCRIPTS += src/interactive/onchange.sh src/interactive/progress.sh src/interactive/screenshot.sh src/interactive/watchscroll.sh
endif

if HAVE_BASH
dist_bin_SCRIPTS += src/bash/findport.sh src/bash/queue.sh src/bash/time.sh src/bash/transpose.sh src/bash/xzdir.sh src/bash/randomstring.sh
endif

if HAVE_BUILD
dist_bin_SCRIPTS += src/build/create-makefileam.sh src/build/create-configureac.sh
endif

if HAVE_GIT
dist_bin_SCRIPTS += src/git/gitfilter.sh src/git/gitarchiveinit.sh src/git/changelogline.sh src/git/changelogupdate.sh src/git/gitoliterepos.sh src/git/githubrepos.sh src/git/pullall.sh src/git/pushall.sh src/git/unstagedfiles.sh src/git/fetchall.sh
endif

if HAVE_DESKTOP
dist_bin_SCRIPTS += src/desktop/executequicksynergy.sh src/desktop/i3background.sh src/desktop/runxclock.sh src/desktop/keymap.sh src/desktop/scrollevince.sh
endif

if HAVE_PDFLATEX
dist_bin_SCRIPTS += src/pdflatex/countcolorpages.sh src/pdflatex/latexrefre.sh src/pdflatex/rebuildlatex.sh
endif

if HAVE_ARCH
dist_bin_SCRIPTS += src/arch/pacman-disowned.sh
endif

if HAVE_DOWNLOAD
dist_bin_SCRIPTS += src/download/kerbalpodcast-dl.sh
endif

if HAVE_MOUNT
dist_bin_SCRIPTS += src/mount/mountasuser.sh
endif

