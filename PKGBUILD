# Maintainer: Adrian <adrian@example.com>

pkgname=arch-remaster
pkgver=26.01
pkgrel=1
pkgdesc="Tools for remastering Arch Linux ISOs and updating live USB GRUB configs"
arch=('any')
url="https://github.com/adrian/arch-remaster"
license=('GPL')
depends=('bash' 'coreutils' 'util-linux' 'grep' 'sed')
optdepends=(
    'squashfs-tools: for iso-remaster and live-remaster'
    'grub: for iso-remaster'
    'xorriso: for iso-remaster'
    'md5sum: for iso-remaster and live-remaster'
)
source=(
    'iso-remaster'
    'live-remaster'
    'update-cow-space'
    'iso-remaster.1'
    'live-remaster.1'
    'update-cow-space.1'
)
md5sums=(
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
)

package() {
    cd "$srcdir"

    # Install scripts
    install -Dm755 "$srcdir/iso-remaster" "$pkgdir/usr/bin/iso-remaster"
    install -Dm755 "$srcdir/live-remaster" "$pkgdir/usr/bin/live-remaster"
    install -Dm755 "$srcdir/update-cow-space" "$pkgdir/usr/bin/update-cow-space"

    # Install man pages
    install -Dm644 "$srcdir/iso-remaster.1" "$pkgdir/usr/share/man/man1/iso-remaster.1"
    install -Dm644 "$srcdir/live-remaster.1" "$pkgdir/usr/share/man/man1/live-remaster.1"
    install -Dm644 "$srcdir/update-cow-space.1" "$pkgdir/usr/share/man/man1/update-cow-space.1"
}