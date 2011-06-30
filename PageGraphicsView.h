#ifndef PageGraphicsView_h
#define PageGraphicsView_h

#include <QGraphicsView>

class CrashGraphicsItem;
class QGraphicsWKView;
class QWKContext;
class QWKPage;

class PageGraphicsView : public QGraphicsView {
    Q_OBJECT

public:
    PageGraphicsView(QWKContext*, QWidget* parent = 0);
    virtual ~PageGraphicsView();

    void load(const QUrl&);
    QWKPage* page() const;

protected:
    virtual void resizeEvent(QResizeEvent*);

private slots:
    void onEngineConnectionChanged(bool);

private:
    CrashGraphicsItem* m_crashItem;
    QGraphicsWKView* m_webViewItem;
};

#endif
