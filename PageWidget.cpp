#include "PageWidget.h"

#include "BrowserWindow.h"
#include "PageGraphicsView.h"
#include <QtGui/QApplication>
#include <QtGui/QLineEdit>
#include <QtGui/QToolBar>
#include <QtGui/QVBoxLayout>
#include <qwkcontext.h>
#include <qwkpage.h>

QWKPage* newPageCallback(QWKPage* parentPage)
{
    BrowserWindow* window = BrowserWindow::create(parentPage->context());
    PageWidget* page = window->openNewTab();
    window->show();
    return page->page();
}

PageWidget::PageWidget(QWKContext* context, QWidget* parent)
    : QWidget(parent)
    , m_urlEdit(0)
    , m_view(0)
    , m_loading(false)
{
    QVBoxLayout* layout = new QVBoxLayout(this);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->setSpacing(0);

    QToolBar* toolBar = new QToolBar;
    m_view = new PageGraphicsView(context);

    layout->addWidget(toolBar);
    layout->addWidget(m_view);

    toolBar->addAction(page()->action(QWKPage::Back));
    toolBar->addAction(page()->action(QWKPage::Forward));
    toolBar->addAction(page()->action(QWKPage::Reload));
    toolBar->addAction(page()->action(QWKPage::Stop));

    QAction* focusLocationBarAction = new QAction(this);
    focusLocationBarAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_L));
    connect(focusLocationBarAction, SIGNAL(triggered()), this, SLOT(focusLocationBar()));
    addAction(focusLocationBarAction);

    QAction* newWindowAction = new QAction(this);
    newWindowAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_N));
    connect(newWindowAction, SIGNAL(triggered()), this, SIGNAL(newWindowRequested()));
    addAction(newWindowAction);

    QAction* newTabAction = new QAction(this);
    newTabAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_T));
    connect(newTabAction, SIGNAL(triggered()), this, SIGNAL(newTabRequested()));
    addAction(newTabAction);

    QAction* closeTabAction = new QAction(this);
    closeTabAction->setShortcut(QKeySequence(Qt::CTRL | Qt::Key_W));
    connect(closeTabAction, SIGNAL(triggered()), this, SIGNAL(closeTabRequested()));
    addAction(closeTabAction);

    m_urlEdit = new QLineEdit;
    toolBar->addWidget(m_urlEdit);

    connect(page(), SIGNAL(loadStarted()), SLOT(focusWebView()));
    connect(page(), SIGNAL(loadStarted()), SLOT(onLoadStarted()));
    connect(page(), SIGNAL(loadFinished(bool)), SLOT(onLoadFinished(bool)));
    connect(page(), SIGNAL(loadProgress(int)), SLOT(onLoadProgress(int)));
    connect(page(), SIGNAL(titleChanged(QString)), SLOT(onTitleChanged(QString)));
    connect(page(), SIGNAL(urlChanged(QUrl)), SLOT(onUrlChanged(QUrl)));
    connect(m_urlEdit, SIGNAL(returnPressed()), this, SLOT(onUrlEditReturnPressed()));

    page()->setCreateNewPageFunction(newPageCallback);

    setFocusProxy(m_urlEdit);
}

PageWidget::~PageWidget()
{
}

QWKPage* PageWidget::page() const
{
    return m_view->page();
}

void PageWidget::load(const QUrl& url)
{
    m_urlEdit->setText(url.toString());
    emit titleChanged(url.toString());
    m_view->load(url);
}

void PageWidget::onLoadProgress(int progress)
{
    QPalette applicationPalette = QApplication::palette();

    QColor backgroundColor = applicationPalette.color(QPalette::Base);
    QColor progressColor = applicationPalette.color(QPalette::Highlight);
    QPalette palette = m_urlEdit->palette();

    if (progress <= 0 || progress >= 100)
        palette.setBrush(QPalette::Base, backgroundColor);
    else {
        QLinearGradient gradient(0, 0, width(), 0);
        gradient.setColorAt(0, progressColor);
        gradient.setColorAt(((double) progress) / 100, progressColor);
        if (progress != 100)
            gradient.setColorAt((double) progress / 100 + 0.001, backgroundColor);
        palette.setBrush(QPalette::Base, gradient);
    }
    m_urlEdit->setPalette(palette);
}

void PageWidget::onTitleChanged(const QString& title)
{
    emit titleChanged(title);
}

void PageWidget::onUrlChanged(const QUrl& url)
{
    m_urlEdit->setText(url.toString());
}

void PageWidget::onUrlEditReturnPressed()
{
    load(QUrl::fromUserInput(m_urlEdit->text()));
}

void PageWidget::focusLocationBar()
{
    m_urlEdit->setFocus();
    m_urlEdit->selectAll();
}

void PageWidget::focusWebView()
{
    m_view->setFocus();
}

void PageWidget::onLoadStarted()
{
    m_loading = true;
    emit loadingStateChanged(true);
}

void PageWidget::onLoadFinished(bool /*ok*/)
{
    m_loading = false;
    emit loadingStateChanged(false);
}

bool PageWidget::isLoading() const
{
    return m_loading;
}
