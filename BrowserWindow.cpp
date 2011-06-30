#include "BrowserWindow.h"
#include "PageWidget.h"
#include <QtCore/QCoreApplication>
#include <QtCore/QUrl>
#include <QtGui/QAction>
#include <QtGui/QImageReader>
#include <qwkcontext.h>
#include <qwkpreferences.h>

BrowserWindow* BrowserWindow::create(QWKContext* context)
{
    return new BrowserWindow(context);
}

static QList<QIcon>& spinnerIcons()
{
    static QList<QIcon> icons;
    if (icons.isEmpty()) {
        QImageReader reader(":/images/spinner.gif", "gif");
        while (reader.canRead())
            icons.append(QIcon(QPixmap::fromImage(reader.read())));
    }
    return icons;
}

BrowserWindow::BrowserWindow(QWKContext* context)
    : QMainWindow(0)
    , m_context(context)
    , m_spinnerIndex(0)
    , m_spinnerTimer(-1)
{
    if (!m_context)
        m_context = new QWKContext;

    setAttribute(Qt::WA_DeleteOnClose);

    m_tabs = new QTabWidget(this);
    m_tabs->setTabsClosable(true);

    connect(m_tabs, SIGNAL(tabCloseRequested(int)), this, SLOT(onTabCloseRequested(int)));
    connect(m_tabs, SIGNAL(currentChanged(int)), this, SLOT(onCurrentTabChanged(int)));

    QAction* nextTabAction = new QAction(this);
    nextTabAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_PageDown));
    connect(nextTabAction, SIGNAL(triggered()), this, SLOT(jumpToNextTab()));
    addAction(nextTabAction);

    QAction* previousTabAction = new QAction(this);
    previousTabAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_PageUp));
    connect(previousTabAction, SIGNAL(triggered()), this, SLOT(jumpToPreviousTab()));
    addAction(previousTabAction);

    setCentralWidget(m_tabs);
    m_tabs->setFocusPolicy(Qt::NoFocus);

    resize(800, 600);
}

PageWidget* BrowserWindow::openInNewTab(const QString& urlFromUserInput)
{
    PageWidget* pageWidget = new PageWidget(m_context);
    m_tabs->addTab(pageWidget, tr("New Tab"));

    connect(pageWidget, SIGNAL(newWindowRequested()), this, SLOT(openNewWindow()));
    connect(pageWidget, SIGNAL(newTabRequested()), this, SLOT(openNewTab()));
    connect(pageWidget, SIGNAL(closeTabRequested()), this, SLOT(closeCurrentTab()));
    connect(pageWidget, SIGNAL(titleChanged(QString)), this, SLOT(onPageTitleChanged(QString)));
    connect(pageWidget, SIGNAL(loadingStateChanged(bool)), this, SLOT(onPageLoadingStateChanged(bool)));

    m_tabs->setCurrentWidget(pageWidget);
    pageWidget->setFocus();

    QUrl url = QUrl::fromUserInput(urlFromUserInput);
    if (!url.isEmpty())
        pageWidget->load(url);

    return pageWidget;
}

BrowserWindow* BrowserWindow::openInNewWindow(const QString& url)
{
    BrowserWindow* window = BrowserWindow::create(m_context);
    window->openInNewTab(url);
    window->show();
    return window;
}

PageWidget* BrowserWindow::openNewTab()
{
    return openInNewTab(QString());
}

BrowserWindow* BrowserWindow::openNewWindow()
{
    return openInNewWindow(QString());
}

void BrowserWindow::closePageWidget(PageWidget* pageWidget)
{
    if (!pageWidget)
        return;

    int tabIndex = m_tabs->indexOf(pageWidget);

    if (tabIndex == -1)
        return;

    m_tabs->removeTab(tabIndex);
    delete pageWidget;

    if (!m_tabs->count())
        close();
}

void BrowserWindow::closeCurrentTab()
{
    closePageWidget(qobject_cast<PageWidget*>(m_tabs->currentWidget()));
}

BrowserWindow::~BrowserWindow()
{
}

void BrowserWindow::jumpToNextTab()
{
    int tabIndex = m_tabs->currentIndex() + 1;
    if (tabIndex >= m_tabs->count())
        tabIndex = 0;

    m_tabs->setCurrentIndex(tabIndex);
}

void BrowserWindow::jumpToPreviousTab()
{
    int tabIndex = m_tabs->currentIndex() - 1;
    if (tabIndex < 0)
        tabIndex = m_tabs->count() - 1;

    m_tabs->setCurrentIndex(tabIndex);
}

void BrowserWindow::onTabCloseRequested(int tabIndex)
{
    closePageWidget(qobject_cast<PageWidget*>(m_tabs->widget(tabIndex)));
}

void BrowserWindow::onPageTitleChanged(const QString& title)
{
    PageWidget* pageWidget = qobject_cast<PageWidget*>(QObject::sender());

    Q_ASSERT(pageWidget);
    if (!pageWidget)
        return;

    int tabIndex = m_tabs->indexOf(pageWidget);
    if (tabIndex == -1)
        return;

    m_tabs->setTabText(tabIndex, title);

    if (tabIndex == m_tabs->currentIndex())
        setFancyWindowTitle(title);
}

void BrowserWindow::onPageLoadingStateChanged(bool /*loading*/)
{
    if (m_spinnerTimer < 0)
        m_spinnerTimer = startTimer(150);
}

void BrowserWindow::timerEvent(QTimerEvent*)
{
    ++m_spinnerIndex;
    if (m_spinnerIndex >= spinnerIcons().count())
        m_spinnerIndex = 0;

    int loadingPages = 0;

    for (int i = 0; i < m_tabs->count(); ++i) {
        PageWidget* pageWidget = qobject_cast<PageWidget*>(m_tabs->widget(i));
        Q_ASSERT(pageWidget);
        if (!pageWidget->isLoading()) {
            // FIXME: Revert to page favicon once Qt/WebKit2 has API for that.
            m_tabs->setTabIcon(i, QIcon());
            continue;
        }
        ++loadingPages;
        m_tabs->setTabIcon(i, spinnerIcons().at(m_spinnerIndex));
    }

    if (!loadingPages && m_spinnerTimer >= 0) {
        killTimer(m_spinnerTimer);
        m_spinnerTimer = -1;
    }
}

void BrowserWindow::onCurrentTabChanged(int tabIndex)
{
    setFancyWindowTitle(m_tabs->tabText(tabIndex));
}

void BrowserWindow::setFancyWindowTitle(const QString& title)
{
    setWindowTitle(QString::fromLatin1("%1 ~ %2").arg(title, QCoreApplication::applicationName()));
}
