#include "PageGraphicsView.h"

#include "CrashGraphicsItem.h"
#include <QtGui/QGraphicsScene>
#include <qgraphicswkview.h>

PageGraphicsView::PageGraphicsView(QWKContext* context, QWidget* parent)
    : QGraphicsView(parent)
    , m_crashItem(0)
{
    m_webViewItem = new QGraphicsWKView(context);
    setScene(new QGraphicsScene(this));
    scene()->addItem(m_webViewItem);
    m_webViewItem->setFocus();

    setFrameShape(QFrame::NoFrame);
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

    connect(page(), SIGNAL(engineConnectionChanged(bool)), SLOT(onEngineConnectionChanged(bool)));
}

PageGraphicsView::~PageGraphicsView()
{
    delete m_webViewItem;
    m_webViewItem = 0;
}

void PageGraphicsView::resizeEvent(QResizeEvent* event)
{
    QGraphicsView::resizeEvent(event);
    QRectF rect(QPoint(0, 0), event->size());
    m_webViewItem->setGeometry(rect);
    if (m_crashItem)
        m_crashItem->setGeometry(rect);
    scene()->setSceneRect(rect);
}

void PageGraphicsView::load(const QUrl& url)
{
    return m_webViewItem->load(url);
}

QWKPage* PageGraphicsView::page() const
{
    return m_webViewItem->page();
}

void PageGraphicsView::onEngineConnectionChanged(bool connected)
{
    if (connected) {
        delete m_crashItem;
        m_crashItem = 0;
        return;
    }

    m_crashItem = new CrashGraphicsItem;
    m_crashItem->setZValue(1);
    m_crashItem->setGeometry(scene()->sceneRect());
    scene()->addItem(m_crashItem);
    m_crashItem->setVisible(true);
}
