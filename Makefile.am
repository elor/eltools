ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS}

dist_bin_SCRIPTS = 

if HAVE_GIT
dist_bin_SCRIPTS += src/git/pushall.sh src/git/fetchall.sh src/git/changelogline.sh src/git/changelogupdate.sh src/git/githubrepos.sh src/git/gitfilter.sh src/git/unstagedfiles.sh src/git/gitoliterepos.sh src/git/gitarchiveinit.sh src/git/pullall.sh
endif

if HAVE_DESKTOP
dist_bin_SCRIPTS += src/desktop/executequicksynergy.sh src/desktop/scrollevince.sh src/desktop/keymap.sh src/desktop/i3background.sh src/desktop/runxclock.sh
endif

if HAVE_PDFLATEX
dist_bin_SCRIPTS += src/pdflatex/rebuildlatex.sh src/pdflatex/countcolorpages.sh src/pdflatex/latexrefre.sh
endif

if HAVE_INTERACTIVE
dist_bin_SCRIPTS += src/interactive/watchscroll.sh src/interactive/screenshot.sh src/interactive/battery.sh src/interactive/progress.sh src/interactive/onchange.sh
endif

if HAVE_MOUNT
dist_bin_SCRIPTS += src/mount/mountasuser.sh src/mount/umountasuser.sh
endif

if HAVE_BUILD
dist_bin_SCRIPTS += src/build/create-configureac.sh src/build/create-makefileam.sh
endif

if HAVE_ARCH
dist_bin_SCRIPTS += src/arch/pacman-disowned.sh
endif

if HAVE_BASH
dist_bin_SCRIPTS += src/bash/queue.sh src/bash/time.sh src/bash/findport.sh src/bash/transpose.sh src/bash/randomstring.sh src/bash/xzdir.sh
endif

if HAVE_DOWNLOAD
dist_bin_SCRIPTS += src/download/kerbalpodcast-dl.sh
endif

if HAVE_CHEM
dist_bin_SCRIPTS += src/chem/temp2vel.py src/chem/element2mass.py src/chem/mass2element.py src/chem/reaxspecies.sh
endif

