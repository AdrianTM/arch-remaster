# Maintainer: Adrian <adrian@mxlinux.org>

pkgname=arch-remaster
pkgver=26.01
pkgrel=2
pkgdesc="Tools for remastering Arch Linux live systems and updating live USB GRUB configs"
arch=('any')
url="https://github.com/AdrianTM/arch-remaster"
license=('GPL')
depends=('bash' 'coreutils' 'util-linux' 'grep' 'sed')
optdepends=(
    'squashfs-tools: for live-remaster'
)
source=(
    'live-remaster'
    'update-cow-space'
    'live-remaster.1'
    'update-cow-space.1'
)
md5sums=(
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
)

package() {
    cd "$srcdir"

    # Install scripts
    install -Dm755 "$srcdir/live-remaster" "$pkgdir/usr/bin/live-remaster"
    install -Dm755 "$srcdir/update-cow-space" "$pkgdir/usr/bin/update-cow-space"

    # Install man pages
    install -Dm644 "$srcdir/live-remaster.1" "$pkgdir/usr/share/man/man1/live-remaster.1"
    install -Dm644 "$srcdir/update-cow-space.1" "$pkgdir/usr/share/man/man1/update-cow-space.1"
}
